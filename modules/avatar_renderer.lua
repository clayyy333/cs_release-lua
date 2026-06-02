local AvatarRenderer = {}

local Players = game:GetService("Players")

local robloxThumbnailCache = {}
local assetImageCache = {}

local function cleanAssetId(assetId)
    if assetId == nil then
        return nil
    end

    local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

    if value == "" or value == "0" or value:lower() == "none" or value:lower() == "null" then
        return nil
    end

    return value
end

local function getAssetThumbnail(assetId)
    return "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=150&h=150"
end

function AvatarRenderer.GetRobloxHeadshot(userId)
    local numericUserId = tonumber(userId)

    if not numericUserId then
        return ""
    end

    if robloxThumbnailCache[numericUserId] then
        return robloxThumbnailCache[numericUserId]
    end

    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            numericUserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    if ok and content then
        robloxThumbnailCache[numericUserId] = content
        return content
    end

    return ""
end

function AvatarRenderer.GetRobloxBust(userId)
    local numericUserId = tonumber(userId)

    if not numericUserId then
        return ""
    end

    local cacheKey = "bust_" .. tostring(numericUserId)

    if robloxThumbnailCache[cacheKey] then
        return robloxThumbnailCache[cacheKey]
    end

    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(
            numericUserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size180x180
        )
    end)

    if ok and content then
        robloxThumbnailCache[cacheKey] = content
        return content
    end

    return AvatarRenderer.GetRobloxHeadshot(numericUserId)
end

function AvatarRenderer.ResolveAssetImage(assetId)
    local value = cleanAssetId(assetId)

    if not value then
        return nil
    end

    if value:match("^rbxassetid://") or value:match("^rbxasset://") or value:match("^http") then
        return value
    end

    if not value:match("^%d+$") then
        return value
    end

    if assetImageCache[value] then
        return assetImageCache[value]
    end

    local assetPath = "rbxassetid://" .. value
    local fallbackImage = getAssetThumbnail(value)
    local resolvedImage = nil

    local success, objects = pcall(function()
        return game:GetObjects(assetPath)
    end)

    if success and objects then
        for _, object in ipairs(objects) do
            if object:IsA("Decal") or object:IsA("Texture") then
                if object.Texture and object.Texture ~= "" then
                    resolvedImage = object.Texture
                    break
                end
            elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                if object.Image and object.Image ~= "" then
                    resolvedImage = object.Image
                    break
                end
            end

            for _, descendant in ipairs(object:GetDescendants()) do
                if descendant:IsA("Decal") or descendant:IsA("Texture") then
                    if descendant.Texture and descendant.Texture ~= "" then
                        resolvedImage = descendant.Texture
                        break
                    end
                elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                    if descendant.Image and descendant.Image ~= "" then
                        resolvedImage = descendant.Image
                        break
                    end
                end
            end

            if resolvedImage then
                break
            end
        end

        for _, object in ipairs(objects) do
            pcall(function()
                object:Destroy()
            end)
        end
    end

    assetImageCache[value] = resolvedImage or fallbackImage

    return assetImageCache[value]
end

function AvatarRenderer.SetAssetPreview(imageLabel, assetId, fallbackImage)
    if not imageLabel then
        return nil
    end

    local image = AvatarRenderer.ResolveAssetImage(assetId)

    imageLabel.BackgroundTransparency = 0
    imageLabel.BackgroundColor3 = Color3.fromRGB(20, 21, 25)
    imageLabel.Image = image or fallbackImage or ""

    return image
end

function AvatarRenderer.SetAvatar(imageLabel, robloxUserId, profileAvatarId, useBust)
    if not imageLabel then
        return
    end

    local fallbackImage = useBust
        and AvatarRenderer.GetRobloxBust(robloxUserId)
        or AvatarRenderer.GetRobloxHeadshot(robloxUserId)

    local customImage = AvatarRenderer.ResolveAssetImage(profileAvatarId)

    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = customImage or fallbackImage

    if customImage and fallbackImage ~= "" then
        task.delay(4, function()
            if not imageLabel.Parent then
                return
            end

            if imageLabel.Image == customImage and imageLabel.IsLoaded == false then
                imageLabel.Image = fallbackImage
            end
        end)
    end
end

return AvatarRenderer
