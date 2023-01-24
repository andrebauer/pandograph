filetype = "svg"
mimetype = "image/svg+xml"

if FORMAT == "docx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "pptx" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "rtf" then
  filetype = "png"
  mimetype = "image/png"
elseif FORMAT == "latex" or FORMAT == "beamer" then
  filetype = "pdf"
  mimetype = "application/pdf"
end


mime_types = {
  ['image/apng'] = 'apng', -- Animated Portable Network Graphics (APNG)
  ['image/avif'] = 'avif', -- AV1 Image File Format (AVIF)
  ['image/gif'] = 'gif', -- Graphics Interchange Format (GIF)
  ['image/jpeg'] = 'jpeg', -- Joint Photographic Expert Group image (JPEG)
  ['image/png'] = 'png', -- Portable Network Graphics (PNG)
  ['image/svg+xml'] = 'svg', -- Scalable Vector Graphics (SVG)
  ['image/webp'] = 'webp', -- Web Picture format (WEBP)
  ['image/bmp'] = 'bmp', -- Bitmap file
  ['image/x-icon'] = 'ico', -- Microsoft icon
  ['image/tiff'] = 'tiff', -- Tagged Image File Format
  ['application/pdf'] = 'pdf',  -- Portable Document Format
}

function ext_of_mimetype(mimetype)
  return mime_types[mimetype]
end
