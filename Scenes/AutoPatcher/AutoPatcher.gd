extends Node
class_name AutoPatcher

const VERSION_FILE_URL := "https://path_to_version.file"
const DOWNLOAD_URL := "https://path_to_file.abc"
const PROJECT_FILE_NAME: String = "file_name_without_extension"
const DELAY_TO_CLORE: float = 0.35
var build_version: int
var remote_version: int

func _ready() -> void:
	var err := $VersionHTTPRequest.connect("request_completed", self, "_on_request_completed")
	var url := "https://raw.githubusercontent.com/coelhucas/mp-game-pck/master/version"
	err = $DownloadHTTPRequest.connect("request_completed", self, "_on_download_completed")
	err = $VersionHTTPRequest.request(url)
	var version: File = File.new()
	err = version.open("version", File.READ)
	build_version = int(version.get_line())
	add_status("Looking for new updates...")
	
	if err != OK:
		push_error("Error: %s" % err)
	
	yield(get_tree().create_timer(0.5), "timeout")

func _on_download_completed(_result: int, response_code: int, _headers: PoolStringArray, _body: PoolByteArray) -> void:
	if response_code == 200:
		var version: File = File.new()
		var err := version.open("version", File.WRITE_READ)
		if err != OK:
			push_error("Error: %s" % err)
			return
		version.store_string(str(remote_version))
		redirect_to_game()

func _on_request_completed(result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	var response_string: String = body.get_string_from_utf8()
	remote_version = int(response_string)
	if remote_version > build_version:
		add_status("New update found!")
		add_status("Starting download of build version: %s" % str(remote_version).pad_zeros(5))
		$UI/Separator/Download.show()
		download(DOWNLOAD_URL, "%s.pck" % PROJECT_FILE_NAME)
	else:
		redirect_to_game()
		
	
func add_status(msg: String) -> void:
	$UI/Separator/StatusLog.append_bbcode("%s\n" % msg)

func download(url : String, file_name : String):
	$DownloadHTTPRequest.set_download_file(file_name)
	$DownloadHTTPRequest.request(url)
	$UpdateCheck.start()

func redirect_to_game() -> void:
	add_status("Game updated.")
	yield(get_tree().create_timer(DELAY_TO_CLORE), "timeout")
	OS.execute("%s.exe" % PROJECT_FILE_NAME, [], false)
	get_tree().quit()

func _on_UpdateCheck_timeout():
	var total_bytes: int = $DownloadHTTPRequest.get_body_size()
	var bytes_downloaded: int = $DownloadHTTPRequest.get_downloaded_bytes()
	var mb_total: float = float(abs(total_bytes)) / 1000000
	var downloaded: float = float(bytes_downloaded) / 1000000
	if $UI/Separator/Download/ProgressBar.max_value == 1 and total_bytes != -1:
		$UI/Separator/Download/ProgressBar.max_value = total_bytes
	$UI/Separator/Download/ProgressBar.value = bytes_downloaded
	
	$UI/Separator/Download/Value.text = "%s MBs / %s MBs downloaded." % [str(downloaded).pad_decimals(2), str(mb_total).pad_decimals(2)]
