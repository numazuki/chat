json.array! @users do |user|
  json.id user.id
  json.name user.name
  json.avatar user.avatar
  json.profile user.profile
  json.search_id user.search_id

end


