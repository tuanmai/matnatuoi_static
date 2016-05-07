json.array!(@weeks) do |order|
  json.extract! order, :id
  json.url week_url(order, format: :json)
end
