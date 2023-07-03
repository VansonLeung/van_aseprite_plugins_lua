--[[

Description:
A script to save all different layers in different files.

Made by Gaspi.
   - Itch.io: https://gaspi.itch.io/
   - Twitter: @_Gaspi
--]]

-- Import main.
local err = dofile("main.lua")
if err ~= 0 then return err end

-- Variable to keep track of the number of layers exported.
local n_layers = 0
-- Exports every layer individually.



local function split_string(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end





local function exportLayers(sprite, root_layer, filename, group_sep, spritesheet, tags, tag, tag_sep, columns, layerGroupNames)

    if tags ~= nil then

        if tags == "" then
            exportLayers(sprite, root_layer, filename, group_sep, spritesheet, nil, "", tag_sep, columns, layerGroupNames)
        else
            local tagArray = split_string(tags, ",")

            for i in pairs(tagArray) do
                exportLayers(sprite, root_layer, filename, group_sep, spritesheet, nil, tagArray[i], tag_sep, columns, layerGroupNames)
            end
        end

        return
    end

    for _, layer in ipairs(root_layer.layers) do
        local filename = filename
        if layer.isGroup then
            -- Recursive for groups.

            if layerGroupNames == "" then

                filename = filename:gsub("{layergroups}",
                    layer.name .. group_sep .. "{layergroups}")
                exportLayers(sprite, layer, filename, group_sep, spritesheet, tags, tag, tag_sep, columns, layerGroupNames)

            else

                local layerGroupNameArray = split_string(layerGroupNames, ",")

                for i in pairs(layerGroupNameArray) do
                    if layerGroupNameArray[i] == layer.name then

                        filename = filename:gsub("{layergroups}",
                            layer.name .. group_sep .. "{layergroups}")
                        exportLayers(sprite, layer, filename, group_sep, spritesheet, tags, tag, tag_sep, columns, layerGroupNames)
                    end
                end
    
            end

        else

            -- Individual layer. Export it.
            local tag_space = tag_sep
            if tag == "" then
                tag_space = ""
            end
            layer.isVisible = true
            filename = filename:gsub("{layergroups}", "")
            filename = filename:gsub("{layername}", layer.name)
            filename = filename:gsub("{tag}", tag)
            filename = filename:gsub("{tag_sep}", tag_space)
            os.execute("mkdir \"" .. Dirname(filename) .. "\"")
            if spritesheet then
                app.command.ExportSpriteSheet{
                    ui=false,
                    askOverwrite=false,
                    type=SpriteSheetType.ROWS,
                    columns=columns,
                    rows=0,
                    width=0,
                    height=0,
                    bestFit=false,
                    textureFilename=filename,
                    dataFilename="",
                    dataFormat=SpriteSheetDataFormat.JSON_HASH,
                    borderPadding=0,
                    shapePadding=0,
                    innerPadding=0,
                    trim=false,
                    extrude=false,
                    openGenerated=false,
                    layer="",
                    tag=tag,
                    splitLayers=false,
                    listLayers=layer,
                    listTags=true,
                    listSlices=true,
                }
            else
                sprite:saveCopyAs(filename)
            end
            layer.isVisible = false
            n_layers = n_layers + 1
        end
    end
end






local spr = app.activeSprite
local tagNames = {}
local layerGroupNames = {}


table.insert(tagNames, "")
table.insert(layerGroupNames, "")



for i,tag in ipairs(spr.tags) do
  table.insert(tagNames, tag.name)
end




for _, layer in ipairs(Sprite.layers) do
    if layer.isGroup then
        table.insert(layerGroupNames, layer.name)
    end
end



-- Open main dialog.
local dlg = Dialog("Export slices")
dlg:file{
    id = "directory",
    label = "Output directory:",
    filename = Sprite.filename,
    open = false
}
dlg:entry{
    id = "filename",
    label = "File name format:",
    text = "{layergroups}{layername}{tag_sep}{tag}"
}




dlg:combobox{
    id = 'selectedFilename',
    label = 'Select filename',
    option = dlg.data.filename,
    options = {
        "{layergroups}{layername}{tag_sep}{tag}", 
        "{layergroups}{tag}{tag_sep}{layername}"
    },
    onchange = (function()
        dlg:modify {
            id = "filename",
            text = dlg.data.selectedFilename
        }
    end)
}

dlg:entry{
    id = "tags",
    label = "Selected tags:",
    text = ""
}

dlg:combobox{
    id = 'tag',
    label = 'Select tag',
    option = '',
    options = tagNames,
    onchange = (function()
        if dlg.data.tag == "" then
            dlg:modify {
                id = "tags",
                text = ""
            }
        end

        if dlg.data.tags == "" then
            dlg:modify {
                id = "tags",
                text = dlg.data.tag
            }
        else 
            dlg:modify {
                id = "tags",
                text = dlg.data.tags .. "," .. dlg.data.tag
            }
        end
    end)
}

dlg:entry{
    id = "layer_groups",
    label = "Selected layer groups:",
    text = ""
}

dlg:combobox{
    id = 'layer_group',
    label = 'Select layer group',
    option = '',
    options = layerGroupNames,
    onchange = (function()
        if dlg.data.layer_groups == "" then
            dlg:modify {
                id = "layer_groups",
                text = ""
            }
        end

        if dlg.data.layer_groups == "" then
            dlg:modify {
                id = "layer_groups",
                text = dlg.data.layer_group
            }
        else 
            dlg:modify {
                id = "layer_groups",
                text = dlg.data.layer_groups .. "," .. dlg.data.layer_group
            }
        end
    end)
}


dlg:combobox{
    id = 'format',
    label = 'Export Format:',
    option = 'png',
    options = {'png', 'gif', 'jpg'}
}
dlg:combobox{
    id = 'group_sep',
    label = 'Group separator:',
    option = Sep,
    options = {Sep, '-', '_'}
}
dlg:combobox{
    id = 'tag_sep',
    label = 'Tag separator:',
    option = '_',
    options = {'_', Sep, '-'}
}
dlg:slider{id = 'scale', label = 'Export Scale:', min = 1, max = 10, value = 1}
dlg:number{id = 'columns', label = 'Columns length:'}
dlg:check{
    id = "spritesheet",
    label = "Export as spritesheet:",
    selected = true
}
dlg:check{id = "save", label = "Save sprite:", selected = false}
dlg:button{id = "ok", text = "Export"}
dlg:button{id = "cancel", text = "Cancel"}
dlg:show()

if not dlg.data.ok then return 0 end

-- Get path and filename
local output_path = Dirname(dlg.data.directory)
local filename = dlg.data.filename .. "." .. dlg.data.format

if output_path == nil then
    local dlg = MsgDialog("Error", "No output directory was specified.")
    dlg:show()
    return 1
end

local group_sep = dlg.data.group_sep
filename = filename:gsub("{spritename}",
                         RemoveExtension(Basename(Sprite.filename)))
filename = filename:gsub("{groupseparator}", group_sep)

-- Finally, perform everything.
Sprite:resize(Sprite.width * dlg.data.scale, Sprite.height * dlg.data.scale)
local layers_visibility_data = HideLayers(Sprite)
exportLayers(Sprite, Sprite, output_path .. filename, group_sep, dlg.data.spritesheet, dlg.data.tags, nil, dlg.data.tag_sep, dlg.data.columns, dlg.data.layer_groups)
RestoreLayersVisibility(Sprite, layers_visibility_data)
Sprite:resize(Sprite.width / dlg.data.scale, Sprite.height / dlg.data.scale)

-- Save the original file if specified
if dlg.data.save then Sprite:saveAs(dlg.data.directory) end

-- Success dialog.
local dlg = MsgDialog("Success!", "Exported " .. n_layers .. " layers." .. dlg.data.columns)
dlg:show()

app.command.OpenInFolder(app.fs.filePath())

return 0
