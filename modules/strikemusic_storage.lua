local Storage = {}

local HttpService = game:GetService("HttpService")

Storage.RootFolder = "StrikeChat"
Storage.MusicFolder = Storage.RootFolder .. "/StrikeMusic"
Storage.MediaFolder = Storage.MusicFolder .. "/media"
Storage.MetadataFolder = Storage.MusicFolder .. "/metadata"
Storage.ThumbnailFolder = Storage.MusicFolder .. "/thumbnails"

local function hasFilesystem()
    return type(isfolder) == "function"
        and type(makefolder) == "function"
        and type(isfile) == "function"
        and type(readfile) == "function"
        and type(writefile) == "function"
end

local function canListFiles()
    return type(listfiles) == "function"
end

local function canDeleteFiles()
    return type(delfile) == "function"
end

local function normalizePath(path)
    return tostring(path or ""):gsub("\\", "/")
end

local function encodeFileName(value)
    local text = tostring(value or "")

    return text
        :gsub("[^%w%-_%.]", "_")
        :sub(1, 120)
end

local function safeDecodeJson(text)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(text)
    end)

    if ok then
        return decoded
    end

    return nil
end

local function safeEncodeJson(value)
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(value)
    end)

    if ok then
        return encoded
    end

    return nil
end

function Storage.HasFilesystem()
    return hasFilesystem()
end

function Storage.EnsureFolders()
    if not hasFilesystem() then
        return {
            status = "blocked",
            reason = "filesystem_not_supported"
        }
    end

    local folders = {
        Storage.RootFolder,
        Storage.MusicFolder,
        Storage.MediaFolder,
        Storage.MetadataFolder,
        Storage.ThumbnailFolder
    }

    for _, folder in ipairs(folders) do
        if not isfolder(folder) then
            makefolder(folder)
        end
    end

    return {
        status = "ok"
    }
end

function Storage.GetFileExtension(mediaType)
    if mediaType == "mp4" then
        return "mp4"
    end

    return "mp3"
end

function Storage.BuildFileKey(sourceId, mediaType, quality)
    local keyParts = {
        encodeFileName(sourceId or HttpService:GenerateGUID(false)),
        encodeFileName(mediaType or "mp3"),
        encodeFileName(quality or Storage.GetDefaultQuality(mediaType))
    }

    return table.concat(keyParts, "_")
end

function Storage.GetDefaultQuality(mediaType)
    if mediaType == "mp4" then
        return "480p"
    end

    return "192kbps"
end

function Storage.GetMediaPath(fileKey, mediaType)
    return Storage.MediaFolder ..
        "/" ..
        encodeFileName(fileKey) ..
        "." ..
        Storage.GetFileExtension(mediaType)
end

function Storage.GetMetadataPath(fileKey)
    return Storage.MetadataFolder ..
        "/" ..
        encodeFileName(fileKey) ..
        ".json"
end

function Storage.GetThumbnailPath(sourceId)
    return Storage.ThumbnailFolder ..
        "/" ..
        encodeFileName(sourceId) ..
        ".jpg"
end

function Storage.MediaExists(metadata)
    if not hasFilesystem() or not metadata then
        return false
    end

    local path = metadata.local_path

    if not path or path == "" then
        path = Storage.GetMediaPath(metadata.file_key, metadata.media_type)
    end

    return isfile(path)
end

function Storage.SaveMetadata(metadata)
    local folderResult = Storage.EnsureFolders()

    if folderResult.status ~= "ok" then
        return folderResult
    end

    if not metadata or not metadata.file_key then
        return {
            status = "blocked",
            reason = "missing_file_key"
        }
    end

    local encoded = safeEncodeJson(metadata)

    if not encoded then
        return {
            status = "blocked",
            reason = "metadata_encode_failed"
        }
    end

    writefile(Storage.GetMetadataPath(metadata.file_key), encoded)

    return {
        status = "saved",
        metadata = metadata
    }
end

function Storage.ReadMetadata(fileKey)
    if not hasFilesystem() then
        return nil
    end

    local path = Storage.GetMetadataPath(fileKey)

    if not isfile(path) then
        return nil
    end

    return safeDecodeJson(readfile(path))
end

function Storage.DeleteMetadata(fileKey)
    if not hasFilesystem() or not canDeleteFiles() then
        return {
            status = "blocked",
            reason = "delete_not_supported"
        }
    end

    local path = Storage.GetMetadataPath(fileKey)

    if isfile(path) then
        delfile(path)
    end

    return {
        status = "deleted"
    }
end

function Storage.DeleteMedia(metadata)
    if not hasFilesystem() or not canDeleteFiles() then
        return {
            status = "blocked",
            reason = "delete_not_supported"
        }
    end

    if not metadata then
        return {
            status = "blocked",
            reason = "metadata_not_found"
        }
    end

    local path = metadata.local_path or Storage.GetMediaPath(
        metadata.file_key,
        metadata.media_type
    )

    if isfile(path) then
        delfile(path)
    end

    Storage.DeleteMetadata(metadata.file_key)

    return {
        status = "deleted"
    }
end

function Storage.ListMetadata()
    local folderResult = Storage.EnsureFolders()

    if folderResult.status ~= "ok" then
        return folderResult
    end

    if not canListFiles() then
        return {
            status = "blocked",
            reason = "listfiles_not_supported",
            items = {}
        }
    end

    local items = {}

    for _, path in ipairs(listfiles(Storage.MetadataFolder)) do
        path = normalizePath(path)

        if path:sub(-5) == ".json" and isfile(path) then
            local metadata = safeDecodeJson(readfile(path))

            if metadata and metadata.file_key then
                table.insert(items, metadata)
            end
        end
    end

    return {
        status = "ok",
        items = items
    }
end

function Storage.GetExistingFileKeys()
    local listResult = Storage.ListMetadata()

    if listResult.status ~= "ok" then
        return listResult
    end

    local keys = {}

    for _, metadata in ipairs(listResult.items) do
        if Storage.MediaExists(metadata) then
            table.insert(keys, metadata.file_key)
        end
    end

    return {
        status = "ok",
        file_keys = keys
    }
end

function Storage.GetLocalLibraryItems()
    local listResult = Storage.ListMetadata()

    if listResult.status ~= "ok" then
        return listResult
    end

    local items = {}
    local removed = {}

    for _, metadata in ipairs(listResult.items) do
        if Storage.MediaExists(metadata) then
            table.insert(items, {
                local_path = metadata.local_path,
                local_thumbnail_path = metadata.local_thumbnail_path,
                media_type = metadata.media_type,
                title = metadata.title,
                artist = metadata.artist,
                duration_seconds = metadata.duration_seconds,
                file_size_bytes = metadata.file_size_bytes,
                quality = metadata.quality,
                thumbnail_url = metadata.thumbnail_url,
                thumbnail_original_url = metadata.thumbnail_original_url,
                source_id = metadata.source_id,
                source_url = metadata.source_url,
                file_key = metadata.file_key
            })
        else
            table.insert(removed, metadata.file_key)
            Storage.DeleteMetadata(metadata.file_key)
        end
    end

    return {
        status = "ok",
        items = items,
        removed_file_keys = removed
    }
end

function Storage.SaveDownloadedMetadata(downloadJob, fileKey, localPath, fileSizeBytes)
    if not downloadJob then
        return {
            status = "blocked",
            reason = "download_job_not_found"
        }
    end

    local thumbnailOriginalUrl = downloadJob.thumbnail_original_url or downloadJob.thumbnail_url

    if thumbnailOriginalUrl and tostring(thumbnailOriginalUrl):match("^rbxasset") then
        thumbnailOriginalUrl = ""
    end

    local metadata = {
        file_key = fileKey,
        local_path = localPath,
        media_type = downloadJob.media_type,
        title = downloadJob.title,
        artist = downloadJob.artist,
        duration_seconds = downloadJob.duration_seconds,
        file_size_bytes = fileSizeBytes,
        quality = downloadJob.quality,
        thumbnail_url = thumbnailOriginalUrl,
        thumbnail_original_url = thumbnailOriginalUrl,
        local_thumbnail_path = downloadJob.local_thumbnail_path,
        source_id = downloadJob.source_id,
        source_url = downloadJob.source_url,
        saved_at = os.time()
    }

    return Storage.SaveMetadata(metadata)
end

return Storage
