transcode evernight mp4 wallpaper
`ffmpeg -i evernight.mp4 -crf 16 evernight.avif`
`ffmpeg -i evernight.mp4 -crf 16 -pix_fmt yuv420p10le -c:v libaom-av1 evernight.avif`

```
ffmpeg -i evernight.mp4 \
  -c:v libwebp_anim \
  -pix_fmt yuv420p \
  -lossless 0 \
  -quality 95 \
  -compression_level 6 \
  -loop 0 \
  -an \
  evernight.webp
```
