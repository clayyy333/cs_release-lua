local Api = {}

Api.BaseUrl = "https://strikechat-api.onrender.com"
Api.AdminCode = ""

local HttpService = game:GetService("HttpService")

local httpRequest =
    request or
    http_request or
    (syn and syn.request)

function Api.HasRequest()
    return httpRequest ~= nil
end

function Api.Encode(value)
    return HttpService:UrlEncode(tostring(value))
end

function Api.Decode(body)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if ok then
        return decoded
    end

    return nil
end

function Api.Request(url, method, body, extraHeaders)
    if not httpRequest then
        return nil
    end

    local headers = {
        ["Content-Type"] = "application/json"
    }

    for key, value in pairs(extraHeaders or {}) do
        headers[key] = value
    end

    local data = {
        Url = url,
        Method = method or "GET",
        Headers = headers
    }

    if body then
        data.Body = HttpService:JSONEncode(body)
    end

    local ok, response = pcall(function()
        return httpRequest(data)
    end)

    if not ok or not response or not response.Body then
        return nil
    end

    return Api.Decode(response.Body)
end

function Api.Heartbeat(player, activity)
    local url =
        Api.BaseUrl ..
        "/online-users/heartbeat" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&roblox_username=" .. Api.Encode(player.Name) ..
        "&roblox_display_name=" .. Api.Encode(player.DisplayName)

    if activity then
        if activity.place_id then
            url = url .. "&place_id=" .. Api.Encode(activity.place_id)
        end

        if activity.place_name and tostring(activity.place_name) ~= "" then
            url = url .. "&place_name=" .. Api.Encode(activity.place_name)
        end
    end

    return Api.Request(url, "POST")
end

function Api.GetOnlineUsers()
    return Api.Request(Api.BaseUrl .. "/online-users", "GET")
end

function Api.GetGlobalMessages()
    return Api.Request(Api.BaseUrl .. "/chat/messages?room_id=global", "GET")
end

function Api.SendGlobalMessage(player, message)
    return Api.Request(
        Api.BaseUrl .. "/chat/send",
        "POST",
        {
            room_id = "global",
            roblox_user_id = player.UserId,
            username = player.DisplayName,
            message = message
        }
    )
end

function Api.GetRoomMessages(roomId)
    return Api.Request(
        Api.BaseUrl .. "/chat/messages?room_id=" .. Api.Encode(roomId),
        "GET"
    )
end

function Api.SendRoomMessage(player, roomId, message)
    return Api.Request(
        Api.BaseUrl .. "/chat/send",
        "POST",
        {
            room_id = roomId,
            roblox_user_id = player.UserId,
            username = player.DisplayName,
            message = message
        }
    )
end

function Api.CreateRoom(player, displayName, isPrivate, password)
    return Api.Request(
        Api.BaseUrl .. "/rooms/create?owner_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            display_name = displayName,
            is_private = isPrivate,
            password = password
        }
    )
end

function Api.GetPublicRooms()
    return Api.Request(Api.BaseUrl .. "/rooms/public", "GET")
end

function Api.GetPrivateRooms()
    return Api.Request(Api.BaseUrl .. "/rooms/private", "GET")
end

function Api.JoinRoom(player, roomId, password)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/join" ..
        "?room_id=" .. Api.Encode(roomId) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            password = password
        }
    )
end

function Api.LeaveRoom(player, roomId)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/leave" ..
        "?room_id=" .. Api.Encode(roomId) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.GetRoomMembers(roomId)
    return Api.Request(
        Api.BaseUrl .. "/rooms/members?room_id=" .. Api.Encode(roomId),
        "GET"
    )
end

function Api.LeaveAnyRoom(player)
    return Api.Request(
        Api.BaseUrl ..
        "/rooms/leave-any" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.GetClans()
    return Api.Request(
        Api.BaseUrl .. "/clans",
        "GET"
    )
end

function Api.CreateClan(player, name, tag, color, tagStyle)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/create" ..
        "?owner_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            name = name,
            tag = tag,
            color = color,
            tag_style = tagStyle
        }
    )
end

function Api.RequestJoinClan(player, clanId)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/join-requests" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&clan_id=" .. Api.Encode(clanId),
        "POST"
    )
end

function Api.GetClanJoinRequests(player)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/join-requests" ..
        "?owner_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end

function Api.GetClanJoinRequestStatus(player, requestId)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/join-requests/status" ..
        "?request_id=" .. Api.Encode(requestId) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end

function Api.RespondClanJoinRequest(player, requestId, decision)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/join-requests/respond" ..
        "?owner_user_id=" .. Api.Encode(player.UserId) ..
        "&request_id=" .. Api.Encode(requestId) ..
        "&decision=" .. Api.Encode(decision),
        "POST"
    )
end

function Api.LeaveClan(player)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/leave" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.DeleteClan(player, clanId)
    return Api.Request(
        Api.BaseUrl ..
        "/clans/delete" ..
        "?owner_user_id=" .. Api.Encode(player.UserId) ..
        "&clan_id=" .. Api.Encode(clanId),
        "DELETE"
    )
end

function Api.GetAdminNotices()
    return Api.Request(
        Api.BaseUrl .. "/admin-notices?platform=external",
        "GET"
    )
end


function Api.SetAdminCode(code)
    Api.AdminCode = tostring(code or "")
end


function Api.GetAdminHeaders(player)
    return {
        ["X-Admin-Code"] = Api.AdminCode or "",
        ["X-Admin-User-Id"] = tostring(player and player.UserId or "")
    }
end


function Api.VerifyAdminAccess(player)
    return Api.Request(
        Api.BaseUrl .. "/admin-auth/verify",
        "GET",
        nil,
        Api.GetAdminHeaders(player)
    )
end


function Api.CreateAdminNotice(player, message)
    return Api.Request(
        Api.BaseUrl .. "/admin-notices/create",
        "POST",
        {
            message = message,
            target_platforms = {"external"}
        },
        Api.GetAdminHeaders(player)
    )
end


function Api.GetPublicProfile(robloxUserId)
    return Api.Request(
        Api.BaseUrl ..
        "/user-profiles/public" ..
        "?roblox_user_id=" .. Api.Encode(robloxUserId),
        "GET"
    )
end


function Api.GetMyProfile(player)
    return Api.Request(
        Api.BaseUrl ..
        "/user-profiles/me" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.SaveMyProfile(player, data)
    return Api.Request(
        Api.BaseUrl ..
        "/user-profiles/me/update" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        data or {}
    )
end


function Api.GetMyInventory(player)
    return Api.Request(
        Api.BaseUrl ..
        "/inventory/my-items" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.UseInventoryItem(player, itemId, styleValue)
    local query =
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&item_id=" .. Api.Encode(itemId)

    if styleValue then
        query = query .. "&style_value=" .. Api.Encode(styleValue)
    end

    return Api.Request(
        Api.BaseUrl ..
        "/inventory/use-item" ..
        query,
        "POST"
    )
end


function Api.DeleteInventoryItem(player, itemId)
    return Api.Request(
        Api.BaseUrl ..
        "/inventory/item" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&item_id=" .. Api.Encode(itemId),
        "DELETE"
    )
end


function Api.GetLimitedRewardStock()
    return Api.Request(
        Api.BaseUrl .. "/shop/limited-stock",
        "GET"
    )
end


function Api.GetPendingRewardRedeems(player)
    return Api.Request(
        Api.BaseUrl .. "/shop/redeems/pending",
        "GET",
        nil,
        Api.GetAdminHeaders(player)
    )
end


function Api.MarkRewardDelivered(player, code)
    return Api.Request(
        Api.BaseUrl ..
        "/shop/redeems/mark-delivered" ..
        "?code=" .. Api.Encode(code),
        "POST",
        nil,
        Api.GetAdminHeaders(player)
    )
end


function Api.BuyShopItem(player, itemId)
    return Api.Request(
        Api.BaseUrl ..
        "/shop/buy" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&item_id=" .. Api.Encode(itemId),
        "POST"
    )
end


function Api.ClaimReward(
    player,
    code
)
    return Api.Request(
        Api.BaseUrl ..
        "/shop/redeems/claim" ..
        "?code=" .. Api.Encode(code) ..
        "&roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.GetPersonalMusicSession(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/session" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.OpenPersonalMusicSession(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/session/open" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.MinimizePersonalMusicSession(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/session/minimize" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.RestorePersonalMusicSession(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/session/restore" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.ClosePersonalMusicSession(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/session/close" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.SearchPersonalMusic(player, query, limit)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/search" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&q=" .. Api.Encode(query or "") ..
        "&limit=" .. Api.Encode(limit or 6),
        "GET"
    )
end


function Api.CreatePersonalMusicDownload(player, downloadData)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        downloadData or {}
    )
end


function Api.GetPersonalMusicDownloads(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.GetPersonalMusicDownload(player, downloadJobId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads/" .. Api.Encode(downloadJobId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.PreparePersonalMusicDownload(player, downloadJobId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads/" .. Api.Encode(downloadJobId) ..
        "/prepare" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.CompletePersonalMusicDownloadLocal(player, downloadJobId, fileKey, fileSizeBytes)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads/" .. Api.Encode(downloadJobId) ..
        "/complete-local" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            file_key = fileKey,
            file_size_bytes = fileSizeBytes
        }
    )
end


function Api.FailPersonalMusicDownload(player, downloadJobId, reason)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads/" .. Api.Encode(downloadJobId) ..
        "/fail" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&reason=" .. Api.Encode(reason or "client_download_failed"),
        "POST"
    )
end


function Api.DeletePersonalMusicDownload(player, downloadJobId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/downloads/" .. Api.Encode(downloadJobId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end

function Api.GetStrikeMusicPopular(limit)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/popular" ..
        "?limit=" .. Api.Encode(limit or 6),
        "GET"
    )
end

function Api.RegisterStrikeMusicPopularPlay(player, catalogTrackId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/popular/" .. Api.Encode(catalogTrackId) ..
        "/play" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end

function Api.RegisterStrikeMusicPersonalPopularPlay(player, payload)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/popular/play" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        payload or {}
    )
end

function Api.AddPersonalRobloxAudio(player, audioId, title, artist)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library/roblox-audio" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            roblox_audio_id = audioId,
            title = title,
            artist = artist
        }
    )
end
function Api.GetPersonalMusicLibrary(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.AddPersonalMusicLibraryItem(player, itemData)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        itemData or {}
    )
end


function Api.RebuildPersonalMusicLibraryLocal(player, items)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library/rebuild-local" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            items = items or {}
        }
    )
end


function Api.SyncPersonalMusicLibraryFiles(player, existingFileKeys)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library/sync-files" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            existing_file_keys = existingFileKeys or {}
        }
    )
end


function Api.DeletePersonalMusicLibraryItem(player, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/library/" .. Api.Encode(libraryItemId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end


function Api.GetPersonalMusicQueue(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/queue" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.AddPersonalMusicQueueItem(player, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/queue" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            library_item_id = libraryItemId
        }
    )
end


function Api.DeletePersonalMusicQueueItem(player, queueItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/queue/" .. Api.Encode(queueItemId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end


function Api.ClearPersonalMusicQueue(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/queue/clear" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.GetPersonalMusicPlayback(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.StartPersonalMusicPlayback(player, libraryItemId, source, positionSeconds, libraryAutoplayEnabled)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/start" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            library_item_id = libraryItemId,
            source = source or "manual",
            position_seconds = positionSeconds or 0,
            library_autoplay_enabled = libraryAutoplayEnabled ~= false
        }
    )
end


function Api.PausePersonalMusicPlayback(player, positionSeconds)
    local body = nil

    if positionSeconds then
        body = {
            position_seconds = positionSeconds
        }
    end

    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/pause" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        body
    )
end


function Api.ResumePersonalMusicPlayback(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/resume" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.StopPersonalMusicPlayback(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/stop" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.UpdatePersonalMusicPlaybackPosition(player, positionSeconds)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/position" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            position_seconds = positionSeconds or 0
        }
    )
end


function Api.PlayNextPersonalMusic(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playback/next" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.GetPersonalMusicHistory(player, limit)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/history" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&limit=" .. Api.Encode(limit or 25),
        "GET"
    )
end


function Api.ClearPersonalMusicHistory(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/history/clear" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST"
    )
end


function Api.GetPersonalMusicFavorites(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/favorites" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.AddPersonalMusicFavorite(player, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/favorites" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId) ..
        "&library_item_id=" .. Api.Encode(libraryItemId),
        "POST"
    )
end


function Api.DeletePersonalMusicFavorite(player, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/favorites/" .. Api.Encode(libraryItemId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end


function Api.GetPersonalMusicPlaylists(player)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.CreatePersonalMusicPlaylist(player, name)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            name = name
        }
    )
end


function Api.GetPersonalMusicPlaylist(player, playlistId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists/" .. Api.Encode(playlistId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "GET"
    )
end


function Api.DeletePersonalMusicPlaylist(player, playlistId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists/" .. Api.Encode(playlistId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end


function Api.AddPersonalMusicPlaylistItem(player, playlistId, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists/" .. Api.Encode(playlistId) ..
        "/items" ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "POST",
        {
            library_item_id = libraryItemId
        }
    )
end


function Api.DeletePersonalMusicPlaylistItem(player, playlistId, libraryItemId)
    return Api.Request(
        Api.BaseUrl ..
        "/strikemusic/personal/playlists/" .. Api.Encode(playlistId) ..
        "/items/" .. Api.Encode(libraryItemId) ..
        "?roblox_user_id=" .. Api.Encode(player.UserId),
        "DELETE"
    )
end

return Api
