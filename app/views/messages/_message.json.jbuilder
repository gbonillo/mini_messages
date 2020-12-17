#
# recursive template
# paramètres :
#   message :
#     message courant
#   all_replies_by_parent :
#     toute les reponses du thread de discussion dans une hashmap par mparent_id (@see Message#load_all_tree_replies_visible)
#     si ce paramètre n'est pas présent on affiche pas du tout les réponses (champs replies) !
#
json.extract! message, :id, :content, :is_public, :created_at, :updated_at
[:author, :dest].each do |attr|
  json.set! attr do
    json.extract! message.send(attr), :id, :name
  end
end
if (all_replies_by_parent)
  if (all_replies_by_parent[message.id])
    json.replies do
      #json.array! message.replies.visible(current_user), partial: "messages/message", as: :message
      json.array! all_replies_by_parent[message.id],
        partial: "messages/message",
        as: :message,
        all_replies_by_parent: all_replies_by_parent,
        show_thread_url: show_thread_url
    end
  else
    json.replies []
  end
end
json.url message_url(message, format: :json)
if (show_thread_url && !message.mroot_id.nil?)
  json.thread_url message_url(message.mroot_id, format: :json)
end
