json.targets @targets do |t|
  json.id         t.id
  json.title      t.title
  json.radius     t.radius
  json.latitude   t.latitude
  json.longitude  t.longitude
  json.topic      t.topic
  json.user       { json.partial! 'api/v1/users/show', user: t.user }
end
