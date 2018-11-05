json.targets @targets do |target|
  json.partial! 'api/v1/targets/target', target: target
end
