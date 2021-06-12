extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var translate: Dictionary = {
	"ru": {
		"PlayButton": "Начать новую игру",
		"ContinueButton": "Продолжить",
		"SettingsButton": "Настройки",
		"ControlInfoButton": "Управление",
		"TitlesButton": "Авторы",
		"ExitButton": "Выход",
		"MusicVolSet": "Громкость музыки: ",
		"SoundVolSet": "Громкость звуков: ",
		"DialogVolSet": "Громкость фраз: ",
		"FullscreenSet": "Полноэкранный режим",
		"LangSet": "Язык",
		"WarnContent": "Данный видеоигровой \"шедевр\" мирового класса строго не рекомендуется детям, нежным личностям, лоу скилл лохам, изичам, анимешникам, фурриебам, хейтерам WheatleyHDD, анонимусам, адептам, фанатикам и сектантам. А еще тут матерятся (но мы запикали), не заходи сюда",
		"WarnSubmitButton": "Понял",
		"WarnExitButton": "Я АСКАРБИЛЬСЯ!",
		"ControlInfo": "Управление:\n[A] - Движение влево\n[D] - Движение вправо\n[Space] - Прыжок\n[E] - Использовать и/или подобрать\n[ЛКМ] - Стрельба\n[R] - Быстрый рестарт",
		"PauseContinue": "Продолжить",
		"PauseRestart": "Перезапустить",
		"PauseToMenu": "Вернуться в меню",
		"PauseLabel": "Пауза",
		"Warn": "В игре используется один из треков, который защищен авторским правом. Он будет помечен значком, который изображен ниже. Удалить мы его просто так не можем, но ютуберы могут заглушить музыку нажатием Ctrl",
	},
	"en": {
		"PlayButton": "Start new game",
		"ContinueButton": "Continue",
		"SettingsButton": "Settings",
		"ControlInfoButton": "Controls",
		"TitlesButton": "Authors",
		"ExitButton": "Exit",
		"MusicVolSet": "Music volume: ",
		"SoundVolSet": "Sound volume: ",
		"DialogVolSet": "Dialogues volume: ",
		"FullscreenSet": "Fullscreen",
		"LangSet": "Language",
		"WarnContent": "This video game \"masterpiece\" of the world class is strictly not recommended for children, gentle personalities, lowskill suckers, IZI4's, anime fans, furry, haters WheatleyHDD, anonymous, adepts, fanatics and sectarians. And then there are using russian foul language, do not come here",
		"WarnSubmitButton": "Got it",
		"WarnExitButton": "ImA lItTlE kIdDo! AAAAAA!",
		"ControlInfo": "Control:\n[A] - Move left\n[D] - Move right\n[Space] - Jump\n[E] - Use\n[ЛКМ] - Shoot\n[R] - Quick restart",
		"PauseContinue": "Continue",
		"PauseRestart": "Restart",
		"PauseToMenu": "Back to Menu",
		"PauseLabel": "Pause",
		"Warn": "The game uses one of the tracks that is protected by copyright. It will be marked with the icon shown below. We can't just delete it, but YouTubers can mute the music by pressing Ctrl",
	},
}
var lang = "ru"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func get_translation(what: String) -> String:
	return translate[lang][what]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
