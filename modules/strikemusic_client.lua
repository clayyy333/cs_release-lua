local StrikeMusicClient = {}

local httpRequest =
    request or
    http_request or
    (syn and syn.request)

local function hasRawRequest()
    return httpRequest ~= nil
end

local function rawGet(url)
    if not hasRawRequest() then
        return nil, "request_not_supported"
    end

    local ok, response = pcall(function()
        return httpRequest({
            Url = url,
            Method = "GET"
        })
    end)

    if not ok or not response then
        return nil, "request_failed"
    end

    if response.StatusCode and response.StatusCode >= 400 then
        return nil, "download_http_error"
    end

    if not response.Body then
        return nil, "download_empty_body"
    end

    return response.Body, nil
end

local function now()
    return os.time()
end

function StrikeMusicClient.Create(Api, Storage)
    local client = {}

    local function ensureReady()
        if not Api then
            return {
                status = "blocked",
                reason = "api_not_configured"
            }
        end

        if not Storage then
            return {
                status = "blocked",
                reason = "storage_not_configured"
            }
        end

        if not Storage.HasFilesystem() then
            return {
                status = "blocked",
                reason = "filesystem_not_supported"
            }
        end

        return {
            status = "ok"
        }
    end

    function client.Open(player)
        local ready = ensureReady()

        if ready.status ~= "ok" then
            return ready
        end

        local folderResult = Storage.EnsureFolders()

        if folderResult.status ~= "ok" then
            return folderResult
        end

        local sessionResult = Api.OpenPersonalMusicSession(player)
        local rebuildResult = client.RebuildLibraryFromLocal(player)

        return {
            status = "ok",
            session = sessionResult,
            rebuild = rebuildResult
        }
    end

    function client.Minimize(player)
        return Api.MinimizePersonalMusicSession(player)
    end

    function client.Restore(player)
        return Api.RestorePersonalMusicSession(player)
    end

    function client.Close(player)
        return Api.ClosePersonalMusicSession(player)
    end

    function client.RebuildLibraryFromLocal(player)
        local localLibrary = Storage.GetLocalLibraryItems()

        if localLibrary.status ~= "ok" then
            return localLibrary
        end

        local rebuildResult = Api.RebuildPersonalMusicLibraryLocal(
            player,
            localLibrary.items
        )

        return {
            status = "ok",
            local_library = localLibrary,
            rebuild = rebuildResult
        }
    end

    function client.SyncExistingFiles(player)
        local keysResult = Storage.GetExistingFileKeys()

        if keysResult.status ~= "ok" then
            return keysResult
        end

        return Api.SyncPersonalMusicLibraryFiles(
            player,
            keysResult.file_keys
        )
    end

    function client.Search(player, query, limit)
        return Api.SearchPersonalMusic(player, query, limit or 6)
    end

    function client.GetLibrary(player)
        return Api.GetPersonalMusicLibrary(player)
    end

    function client.GetDownloads(player)
        return Api.GetPersonalMusicDownloads(player)
    end

    function client.GetQueue(player)
        return Api.GetPersonalMusicQueue(player)
    end

    function client.GetHistory(player, limit)
        return Api.GetPersonalMusicHistory(player, limit or 25)
    end

    function client.GetFavorites(player)
        return Api.GetPersonalMusicFavorites(player)
    end

    function client.BuildDownloadData(result, mediaType)
        mediaType = mediaType or "mp3"

        return {
            source = result.source or "unknown",
            source_id = result.source_id or result.source_url or result.title,
            source_url = result.source_url,
            title = result.title or "StrikeMusic",
            artist = result.artist,
            duration_seconds = result.duration_seconds,
            thumbnail_url = result.thumbnail_url,
            media_type = mediaType,
            quality = Storage.GetDefaultQuality(mediaType)
        }
    end

    function client.CreateDownload(player, result, mediaType)
        print("StrikeMusic: creating job", tostring(mediaType), tostring(result and result.source_id or "unknown"))

        local createResult = Api.CreatePersonalMusicDownload(
            player,
            client.BuildDownloadData(result, mediaType)
        )

        print("StrikeMusic: job created", tostring(createResult and createResult.status or "nil"), tostring(createResult and createResult.reason or ""))
        return createResult
    end

    function client.PrepareDownload(player, downloadJobId)
        print("StrikeMusic: preparing job", tostring(downloadJobId))
        local prepareResult = Api.PreparePersonalMusicDownload(player, downloadJobId)
        print("StrikeMusic: job prepared", tostring(prepareResult and prepareResult.status or "nil"), tostring(prepareResult and prepareResult.reason or ""))
        return prepareResult
    end

    function client.WaitForReadyDownload(player, downloadJobId, timeoutSeconds)
        local startedAt = os.clock()
        timeoutSeconds = timeoutSeconds or 30

        while os.clock() - startedAt <= timeoutSeconds do
            local result = Api.GetPersonalMusicDownload(player, downloadJobId)
            local job = result and result.job

            if job then
                if job.status == "ready" then
                    return {
                        status = "ready",
                        job = job
                    }
                end

                if job.status == "failed" or job.status == "expired" then
                    return {
                        status = "blocked",
                        reason = job.error_reason or job.status,
                        job = job
                    }
                end
            end

            task.wait(1)
        end

        return {
            status = "blocked",
            reason = "download_ready_timeout"
        }
    end

    function client.DownloadReadyJob(player, job)
        local ready = ensureReady()

        if ready.status ~= "ok" then
            return ready
        end

        if not job or not job.download_job_id then
            return {
                status = "blocked",
                reason = "download_job_not_found"
            }
        end

        if job.status ~= "ready" or not job.download_url then
            return {
                status = "blocked",
                reason = "download_job_not_ready",
                job = job
            }
        end

        print("StrikeMusic: downloading prepared file", tostring(job.download_job_id))

        local body, downloadError = rawGet(job.download_url)

        if not body then
            Api.FailPersonalMusicDownload(
                player,
                job.download_job_id,
                downloadError or "client_download_failed"
            )

            return {
                status = "blocked",
                reason = downloadError or "client_download_failed",
                job = job
            }
        end

        local fileKey = Storage.BuildFileKey(
            job.source_id or job.download_job_id,
            job.media_type,
            job.quality
        )
        local localPath = Storage.GetMediaPath(fileKey, job.media_type)
        local folderResult = Storage.EnsureFolders()

        if folderResult.status ~= "ok" then
            return folderResult
        end

        writefile(localPath, body)
        client.CacheThumbnail(job)

        local fileSizeBytes = #body
        local metadataResult = Storage.SaveDownloadedMetadata(
            job,
            fileKey,
            localPath,
            fileSizeBytes
        )

        if metadataResult.status ~= "saved" then
            return metadataResult
        end

        local completeResult = Api.CompletePersonalMusicDownloadLocal(
            player,
            job.download_job_id,
            fileKey,
            fileSizeBytes
        )

        if completeResult and completeResult.item and metadataResult.metadata then
            metadataResult.metadata.library_item_id = completeResult.item.library_item_id
            Storage.SaveMetadata(metadataResult.metadata)
        end

        return {
            status = "downloaded",
            file_key = fileKey,
            local_path = localPath,
            file_size_bytes = fileSizeBytes,
            metadata = metadataResult.metadata,
            complete = completeResult,
            saved_at = now()
        }
    end

    function client.DownloadResult(player, result, mediaType)
        local createResult = client.CreateDownload(player, result, mediaType)
        local job = createResult and createResult.job

        if not job then
            return {
                status = "blocked",
                reason = createResult and createResult.reason or "download_create_failed",
                result = createResult
            }
        end

        local prepareResult = client.PrepareDownload(player, job.download_job_id)
        local preparedJob = prepareResult and prepareResult.job

        if not preparedJob then
            return {
                status = "blocked",
                reason = prepareResult and prepareResult.reason or "download_prepare_failed",
                result = prepareResult
            }
        end

        if preparedJob.status ~= "ready" then
            local waitResult = client.WaitForReadyDownload(
                player,
                preparedJob.download_job_id
            )

            if waitResult.status ~= "ready" then
                return waitResult
            end

            preparedJob = waitResult.job
        end

        return client.DownloadReadyJob(player, preparedJob)
    end

    function client.DeleteDownloadJob(player, downloadJobId)
        if not downloadJobId or tostring(downloadJobId) == "" then
            return {
                status = "blocked",
                reason = "download_job_not_found"
            }
        end

        return Api.DeletePersonalMusicDownload(player, downloadJobId)
    end
    function client.DeleteLocalItem(player, metadata)
        local deleteResult = Storage.DeleteMedia(metadata)

        if deleteResult.status ~= "deleted" then
            return deleteResult
        end

        local syncResult = client.SyncExistingFiles(player)

        return {
            status = "deleted",
            sync = syncResult
        }
    end

    function client.StartPlayback(player, libraryItemId, source, positionSeconds)
        return Api.StartPersonalMusicPlayback(
            player,
            libraryItemId,
            source or "manual",
            positionSeconds or 0,
            true
        )
    end

    function client.PausePlayback(player, positionSeconds)
        return Api.PausePersonalMusicPlayback(player, positionSeconds)
    end

    function client.ResumePlayback(player)
        return Api.ResumePersonalMusicPlayback(player)
    end

    function client.StopPlayback(player)
        return Api.StopPersonalMusicPlayback(player)
    end

    function client.UpdatePlaybackPosition(player, positionSeconds)
        return Api.UpdatePersonalMusicPlaybackPosition(
            player,
            positionSeconds or 0
        )
    end

    function client.PlayNext(player)
        return Api.PlayNextPersonalMusic(player)
    end

    function client.AddToQueue(player, libraryItemId)
        return Api.AddPersonalMusicQueueItem(player, libraryItemId)
    end

    function client.ClearQueue(player)
        return Api.ClearPersonalMusicQueue(player)
    end

    function client.AddFavorite(player, libraryItemId)
        return Api.AddPersonalMusicFavorite(player, libraryItemId)
    end

    function client.DeleteFavorite(player, libraryItemId)
        return Api.DeletePersonalMusicFavorite(player, libraryItemId)
    end


    function client.GetPlaylists(player)
        return Api.GetPersonalMusicPlaylists(player)
    end

    function client.CreatePlaylist(player, name)
        return Api.CreatePersonalMusicPlaylist(player, name)
    end

    function client.GetPlaylist(player, playlistId)
        return Api.GetPersonalMusicPlaylist(player, playlistId)
    end

    function client.DeletePlaylist(player, playlistId)
        return Api.DeletePersonalMusicPlaylist(player, playlistId)
    end

    function client.AddToPlaylist(player, playlistId, libraryItemId)
        return Api.AddPersonalMusicPlaylistItem(player, playlistId, libraryItemId)
    end

    function client.DeleteFromPlaylist(player, playlistId, libraryItemId)
        return Api.DeletePersonalMusicPlaylistItem(player, playlistId, libraryItemId)
    end

    function client.GetPopular(limit)
        return Api.GetStrikeMusicPopular(limit or 4)
    end

    function client.RegisterPopularPlay(player, payload)
        return Api.RegisterStrikeMusicPersonalPopularPlay(player, payload)
    end
    function client.AddRobloxAudio(player, track)
        if not track or not track.roblox_audio_id then
            return {
                status = "blocked",
                reason = "roblox_audio_id_required"
            }
        end

        return Api.AddPersonalRobloxAudio(
            player,
            track.roblox_audio_id,
            track.title,
            track.artist
        )
    end

    local activeRobloxSound = nil
    local robloxAudioEndedHandler = nil

    function client.PlayRobloxAudio(audioId, volume)
        audioId = tonumber(audioId)

        if not audioId or audioId <= 0 then
            return {
                status = "blocked",
                reason = "invalid_roblox_audio_id"
            }
        end

        if activeRobloxSound then
            local previousSound = activeRobloxSound
            activeRobloxSound = nil
            previousSound:Stop()
            previousSound:Destroy()
        end

        local soundService = game:GetService("SoundService")
        local sound = Instance.new("Sound")
        sound.Name = "StrikeMusicRobloxAudio"
        sound.SoundId = "rbxassetid://" .. tostring(math.floor(audioId))
        sound.Volume = math.clamp(tonumber(volume) or 0.5, 0, 1)
        sound.Parent = soundService
        activeRobloxSound = sound

        sound.Ended:Connect(function()
            if activeRobloxSound ~= sound then
                return
            end

            activeRobloxSound = nil
            sound:Destroy()

            if robloxAudioEndedHandler then
                robloxAudioEndedHandler()
            end
        end)

        sound:Play()

        return {
            status = "playing",
            sound = sound
        }
    end

    function client.StopRobloxAudio()
        if activeRobloxSound then
            local sound = activeRobloxSound
            activeRobloxSound = nil
            sound:Stop()
            sound:Destroy()
        end
    end

    function client.PauseRobloxAudio()
        if not activeRobloxSound or not activeRobloxSound.IsPlaying then
            return {
                status = "idle"
            }
        end

        activeRobloxSound:Pause()

        return {
            status = "paused",
            position_seconds = activeRobloxSound.TimePosition
        }
    end

    function client.ResumeRobloxAudio()
        if not activeRobloxSound then
            return {
                status = "idle"
            }
        end

        activeRobloxSound:Resume()

        return {
            status = "playing",
            position_seconds = activeRobloxSound.TimePosition
        }
    end

    function client.SetRobloxAudioVolume(volume)
        local safeVolume = math.clamp(tonumber(volume) or 0.5, 0, 1)

        if activeRobloxSound then
            activeRobloxSound.Volume = safeVolume
        end

        return safeVolume
    end

    function client.SetRobloxAudioTimePosition(positionSeconds)
        if not activeRobloxSound then
            return false
        end

        local safePosition = math.max(tonumber(positionSeconds) or 0, 0)
        local ok = pcall(function()
            activeRobloxSound.TimePosition = safePosition
        end)

        return ok
    end

    function client.GetRobloxAudioState()
        if not activeRobloxSound then
            return {
                status = "idle",
                position_seconds = 0,
                duration_seconds = 0
            }
        end

        return {
            status = activeRobloxSound.IsPlaying and "playing" or "paused",
            position_seconds = activeRobloxSound.TimePosition,
            duration_seconds = activeRobloxSound.TimeLength,
            volume = activeRobloxSound.Volume
        }
    end

    function client.SetRobloxAudioEndedHandler(handler)
        robloxAudioEndedHandler = handler
    end
    local function getLocalAssetLoader()
        if type(getsynasset) == "function" then
            return getsynasset, "getsynasset"
        end

        if type(getcustomasset) == "function" then
            return getcustomasset, "getcustomasset"
        end

        if type(getasset) == "function" then
            return getasset, "getasset"
        end

        return nil, nil
    end

    local function loadLocalThumbnail(item, thumbnailPath)
        if not thumbnailPath or thumbnailPath == "" or not isfile(thumbnailPath) then
            return false
        end

        item.local_thumbnail_path = thumbnailPath

        local assetLoader = getLocalAssetLoader()

        if not assetLoader then
            item.thumbnail_debug = "local_asset_loader_not_supported"
            return true
        end

        local loaded, assetId = pcall(function()
            return assetLoader(thumbnailPath)
        end)

        if loaded and type(assetId) == "string" and assetId ~= "" then
            item.thumbnail_url = assetId
            item.thumbnail_debug = "ready"
        else
            item.thumbnail_debug = "thumbnail_asset_load_failed"
        end

        return true
    end

    function client.CacheThumbnail(item)
        if not item then
            return item
        end

        if not Storage.HasFilesystem() then
            item.thumbnail_debug = "filesystem_not_supported"
            return item
        end

        if item.local_thumbnail_path
            and loadLocalThumbnail(item, tostring(item.local_thumbnail_path))
        then
            return item
        end

        local thumbnailUrl = tostring(item.thumbnail_original_url or item.thumbnail_url or "")

        if (thumbnailUrl == "" or thumbnailUrl:match("^rbxasset"))
            and item.source_id
            and tostring(item.source_id) ~= ""
        then
            thumbnailUrl = "https://i.ytimg.com/vi/" .. tostring(item.source_id) .. "/hqdefault.jpg"
        end

        if thumbnailUrl == "" then
            item.thumbnail_debug = "thumbnail_url_missing"
            return item
        end

        if thumbnailUrl:match("^rbxasset") then
            item.thumbnail_debug = "thumbnail_url_stale"
            return item
        end

        local cacheKey = "thumbnail_" .. tostring(
            item.source_id or item.roblox_audio_id or item.title or "unknown"
        )
        local thumbnailPath = Storage.GetThumbnailPath(cacheKey)
        local folderResult = Storage.EnsureFolders()

        if folderResult.status ~= "ok" then
            item.thumbnail_debug = folderResult.reason or "thumbnail_folder_failed"
            return item
        end

        if not isfile(thumbnailPath) then
            local imageBody = rawGet(thumbnailUrl)

            if not imageBody then
                item.thumbnail_debug = "thumbnail_download_failed"
                return item
            end

            writefile(thumbnailPath, imageBody)
        end

        item.thumbnail_original_url = thumbnailUrl
        loadLocalThumbnail(item, thumbnailPath)

        return item
    end
    function client.GetLocalAudioSupport()
        if not Storage.HasFilesystem() then
            return {
                supported = false,
                reason = "filesystem_not_supported"
            }
        end

        local _, loaderName = getLocalAssetLoader()

        if not loaderName then
            return {
                supported = false,
                reason = "local_asset_loader_not_supported"
            }
        end

        return {
            supported = true,
            loader = loaderName
        }
    end

    function client.PlayLocalAudio(metadata, volume)
        if not metadata or metadata.media_type ~= "mp3" then
            return {
                status = "blocked",
                reason = "local_audio_mp3_required"
            }
        end

        if not Storage.MediaExists(metadata) then
            return {
                status = "blocked",
                reason = "local_audio_file_not_found"
            }
        end

        local assetLoader, loaderName = getLocalAssetLoader()

        if not assetLoader then
            return {
                status = "blocked",
                reason = "local_asset_loader_not_supported"
            }
        end

        local localPath = metadata.local_path or Storage.GetMediaPath(
            metadata.file_key,
            metadata.media_type
        )
        local loaded, assetId = pcall(function()
            return assetLoader(localPath)
        end)

        if not loaded or type(assetId) ~= "string" or assetId == "" then
            return {
                status = "blocked",
                reason = "local_asset_load_failed",
                loader = loaderName
            }
        end

        client.StopRobloxAudio()

        local sound = Instance.new("Sound")
        sound.Name = "StrikeMusicLocalAudio"
        sound.SoundId = assetId
        sound.Volume = math.clamp(tonumber(volume) or 0.5, 0, 1)
        sound.Parent = game:GetService("SoundService")
        activeRobloxSound = sound

        sound.Ended:Connect(function()
            if activeRobloxSound ~= sound then
                return
            end

            activeRobloxSound = nil
            sound:Destroy()

            if robloxAudioEndedHandler then
                robloxAudioEndedHandler()
            end
        end)

        sound:Play()

        return {
            status = "playing",
            sound = sound,
            loader = loaderName
        }
    end
    return client
end

return StrikeMusicClient
