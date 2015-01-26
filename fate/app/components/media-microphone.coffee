`import Ember from 'ember'`
`import MediaCameraComponent from './media-camera'`

MediaMicrophoneComponent = MediaCameraComponent.extend
  contraints:
    audio: true
    video: false
`export default MediaMicrophoneComponent`