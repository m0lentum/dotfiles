# creates a slideshow with a fade effect
# as described here: https://www.bannerbear.com/blog/how-to-create-a-slideshow-from-images-with-ffmpeg/
def mkslides [
  files: list,
  --frametime: duration = 2sec,
  --lastframetime: duration = 4sec,
  --fadetime: duration = 0.5sec,
  --downscale: int = 1,
  --odd-downscale,
  --out-file: string = "out.mp4",
] {
  let frame_time_str = ($frametime | format duration sec | str substring 0..-5)
  let last_frame_time_str = ($lastframetime | format duration sec | str substring 0..-5)
  let fade_time_str = ($fadetime | format duration sec | str substring 0..-5)
  let main_files = ($files | drop 1)
  let last_file = ($files | last 1).0
  let file_count = ($files | length)

  let input_rows = ($main_files | each {
    [-loop "1" -t ($frame_time_str) -i ($in)]
  } | flatten) ++ [
    -loop "1" -t ($last_frame_time_str) -i ($last_file)
  ]
  
  let fade_filters = (1..($file_count - 1) | each {
    let starttime = ($in * $frametime | format duration sec | str substring 0..-5)
    $"[($in)]fade=d=($fade_time_str):alpha=1,setpts=PTS-STARTPTS+($starttime)/TB[f($in - 1)];"
  })

  let overlay_filters = [
    "[0][f0]overlay[bg1];"
    ...(if $file_count > 3 {
        1..($file_count - 3) | each {
          $"[bg($in)][f($in)]overlay[bg($in + 1)];"
        }
      } else { [] }
    )
    $"[bg($file_count - 2)][f($file_count - 2)]overlay,"
  ]

  let scale = if $odd_downscale {
    $"iw/($downscale)-1:-2"
  } else {
    $"iw/($downscale):-1"
  }

  let full_filter = [
    ...$fade_filters,
    ...$overlay_filters,
    "format=yuv420p,",
    $"scale=($scale)[v]",
  ]

  (
    ffmpeg ...$input_rows
    -filter_complex ($full_filter | str join)
    -map "[v]"
    -r 24
    $out_file
  )
}
