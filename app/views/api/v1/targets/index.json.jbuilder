json.targets @targets do |t|
  json.partial! 'api/v1/targets/target', target: t
end
