
#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьПредставлениеСтраныПоКоду(КодСтраны) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодСтраны", КодСтраны);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтраныМира.Ссылка.Наименование КАК Страна
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира
	|ГДЕ
	|	СтраныМира.Код = &КодСтраны";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Возврат ?(Выборка.Следующий(), Выборка.Страна, "");

КонецФункции

#КонецОбласти
