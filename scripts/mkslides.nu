# Creates a slideshow with a fade effect using ffmpeg
# as described here: https://www.bannerbear.com/blog/how-to-create-a-slideshow-from-images-with-ffmpeg/
#
# Note: this can eat up a lot of memory with large images.
# Downscaling the images manually beforehand
# (instead of using the --downscale option) may be a good idea.
# Also, all images should be the same resolution;
# this does not scale them individually.
def mkslides [
  files: list, # List of file paths to include in the slideshow.
  --frametime (-t): duration = 2sec, # Time to display a frame.
  --lastframetime (-l): duration = 5sec, # Time to display the final frame.
  --fadetime (-d): duration = 0.5sec, # Time taken by the fade effect between frames.
  --downscale (-s): int = 1, # Scale the final video down by an integer factor, e.g. 2 will half the resolution.
  --odd-downscale, # The command may fail if your image resolution isn't divisible by the given downscale factor.
    # This fixes it for cases where it's off by one by subtracting one pixel.
    # Other cases can only appear with downscale factors greater than 2
    # and are currently not supported.
  --out-file (-o): string = "out.mp4", # Set the file name for the output.
]: list<string> -> nothing {
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
