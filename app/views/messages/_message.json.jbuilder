#
# recursive template
# paramètres :
#   message :
#     message courant
#   allRepliesByParent :
#     toute les reponses du fil de discussion dans une hashmap par mparent_id (@see Message#load_all_tree_replies_visible)
#     si ce paramètre n'est pas présent on affiche pas du tout les réponses (champs replies) !
#
json.extract! message, :id, :content, :is_public, :created_at, :updated_at
[:author, :dest].each do |attr|
  json.set! attr do
    json.extract! message.send(attr), :id, :name
  end
end
if (allRepliesByParent)
  if (allRepliesByParent[message.id])
    json.replies do
      #json.array! message.replies.visible(current_user), partial: "messages/message", as: :message
      json.array! allRepliesByParent[message.id], partial: "messages/message", as: :message, allRepliesByParent: allRepliesByParent
    end
  else
    json.replies []
  end
end
json.url message_url(message, format: :json)
