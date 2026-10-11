class_name Conversation extends Resource

## part of date with lydia

## lines of dialogue she speaks in this part of conversation
@export_multiline var lines: PackedStringArray
## the topic of the overall conversation.
## she writes a comment on a post and the player finds the topic from there
@export var topic: TopicTemplate
## lines to speak if the player's response is on topic, before the next conversation
@export_multiline var on_topic_lines: PackedStringArray
## lines to speak if the player's response is off topic,  before the next conversation
@export_multiline var off_topic_lines: PackedStringArray
