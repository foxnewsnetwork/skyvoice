# Webcam stream
# cvlc v4l2:///dev/video0 :v4l2-standard= :live-caching=300 :sout="#transcode{vcodec=WMV2,vb=800,scale=1,acodec=wma2,ab=128,channels=2,samplerate=44100}:http{dst=:8080/stream.wmv}"

## From VLC
# :sout=#transcode{vcodec=h264,acodec=mpga,ab=128,channels=2,samplerate=44100}:http{dst=:8080/stream.mp4} :sout-keep

# :sout=#transcode{vcodec=VP80,vb=2000,acodec=vorb,ab=128,channels=2,samplerate=44100}:http{mux=webm,dst=:8080/stream.webm} :sout-keep

# Some input stream from https://github.com/elthariel/activevlc
# vlc input.mp4 :sout="#transcode{deinterlace, acodec=aac, ab=128, channels=2, vcodec=h264, venc=x264{bpyramid=strict, bframes=4, no-cabac}, vb=512}:duplicate{dst=standard{mux=mp4, dst='output.mp4'}, dst=display}"

ActiveVlc::pipe do
  transcode do
    deinterlace
    audio :aac do
      bitrate 128 # 128 kpbs
      channels 2
    end
    video :h264 do
      encoder :x264 do
        bpyramid :strict
        bframes 4
        cabac false
      end
      bitrate 512 # 512 kbps
    end
  end
  # duplicate do
  #   to :file do
  #     mux :mp4
  #     dst 'output.mp4'
  #   end
  #   to :display
  # end
  http do
    dst :":8080/stream.mp4"
  end
end