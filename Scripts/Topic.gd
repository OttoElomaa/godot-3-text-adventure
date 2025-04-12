extends Node




export (String) var topic_id := "Topic ID"
export (String) var keyword := "Keyword"
export (String) var topic_text := "Topic Text Here"
export (Array) var related_topics := []



func setup(id, keyw, text, rel_topics):
	
	topic_id = id
	keyword = keyw
	topic_text = text
	related_topics = rel_topics



func print_to_string():
	
	print("TOPIC: " + topic_id)
	print("" + keyword)
	print("" + topic_text)
	
	for rel in related_topics:
		print(rel)
		
	print("")
	













