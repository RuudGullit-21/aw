#Область СлужебныеПроцедурыИФункции

Функция ВидОшибкиНедействительныйПользователь() Экспорт
	
	ВидОшибки = ОбработкаНеисправностейБЭДКлиентСервер.НовоеОписаниеВидаОшибки();
	ВидОшибки.Идентификатор = "НедействительныйПользователь";
	ВидОшибки.ЗаголовокПроблемы = НСтр("ru = 'Пользователь недействителен'");
	ВидОшибки.ОписаниеПроблемы = НСтр("ru = 'Обработка электронных документов запрещена'");
	ВидОшибки.ОписаниеРешения = НСтр("ru = 'Обратитесь к администратору для настройки параметров пользователя.'");
	
	Возврат ВидОшибки;
	
КонецФункции

Функция ИндексПиктограммыФайла(РасширениеФайла) Экспорт
	Возврат РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(РасширениеФайла);		
КонецФункции

#КонецОбласти