class_name GameResources extends Resource

## responses lydia will randomly leave on randomly generated glepy posts.
## the "post title" field will be ignored because its randomly generated.
## the title field is optional in here, it will just use the comment text.
@export var random_lydia_responses: Array[TopicTemplate]

## the date you will have with lydia.. parts of conversation
@export var date: Array[Conversation]

## love required to win the game
@export_range(1.0, 30.0) var required_love: float
