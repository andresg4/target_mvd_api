json.targets @targets do |target|
  json.id         target.id
  json.title      target.title
  json.radius     target.radius
  json.latitude   target.latitude
  json.longitude  target.longitude
  json.topic      target.topic
  json.user       { json.partial! 'api/v1/users/show', user: target.user }
end
