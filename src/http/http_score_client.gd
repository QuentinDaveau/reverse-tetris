extends HTTPRequest

signal request_treated(status, value)


func _ready():
	connect("request_completed", self, "_http_request_completed")


func get_scores() -> void:
	var error = request("http://pangolin.heliohost.org/get_scores.php")
	if error != OK:
		return


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body) -> void:
	if response_code != 200:
		push_error("bad response code!")
		emit_signal("request_treated", false)
		return
	var response = parse_json(body.get_string_from_utf8())
	emit_signal("request_treated", true, response.scores)
