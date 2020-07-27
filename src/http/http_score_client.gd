extends HTTPRequest

signal request_treated(status, value)

var _request_url: String = "https://pangolin.heliohost.org/get_scores.php"
var _push_url: String = "https://pangolin.heliohost.org/push_score.php"


func _ready():
	connect("request_completed", self, "_http_request_completed")


func get_scores(filter: String = "", sort_by: String = "") -> void:
	var temp_url = _request_url
	match sort_by:
		"Score":
			temp_url += "?sort_by=score"
		"Name":
			temp_url += "?sort_by=username"
		"Date":
			temp_url += "?sort_by=created"
	
	if filter:
		temp_url += "&filter="+filter
	var error = request(temp_url)
	if error != OK:
		return


func send_score(score: int, user_name: String = "Random player") -> void:
	var temp_url = _push_url
	temp_url += "?score="+String(score)
	temp_url += "&user_name="+user_name
	var error = request(temp_url)
	if error != OK:
		return


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body) -> void:
	if response_code != 200:
		push_error("bad response code!: " + String(response_code) + " " + String(body) + " " + String(headers))
		emit_signal("request_treated", false, [])
		return
	var response = parse_json(body.get_string_from_utf8())
	if not response or not response.has("operation"):
		push_error("cannot parse JSON: " + String(response_code) + " " + String(body) + " " + String(headers))
		emit_signal("request_treated", false, [])
		return
	if response.operation == "get_scores":
		emit_signal("request_treated", true, response.scores)
	if response.operation == "push_score":
		emit_signal("request_treated", true, response.rank[0])
