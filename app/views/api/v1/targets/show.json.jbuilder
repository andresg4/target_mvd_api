json.partial! 'api/v1/targets/target', target: target
json.match_targets @matched_targets do |target|
  json.partial! 'api/v1/targets/target', target: target
end
