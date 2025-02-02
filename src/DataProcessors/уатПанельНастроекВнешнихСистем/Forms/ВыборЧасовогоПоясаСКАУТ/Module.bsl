
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Обработка          = РеквизитФормыВЗначение("Объект");
	МакетЧасовыхПоясов = Обработка.ПолучитьМакет("ЧасовыеПоясаСКАУТ"); 
	
	Для НомерСтроки = 2 По 131 Цикл // В первой строке - шапка, всего 131 строка.
		НоваяСтрока = ТаблицаЧасовыхПоясов.Добавить();
		НоваяСтрока.Olson_id    = МакетЧасовыхПоясов.Область(НомерСтроки, 1, НомерСтроки, 1).Текст;
		НоваяСтрока.Name        = МакетЧасовыхПоясов.Область(НомерСтроки, 2, НомерСтроки, 2).Текст;
		НоваяСтрока.Description = МакетЧасовыхПоясов.Область(НомерСтроки, 3, НомерСтроки, 3).Текст;
	КонецЦикла;
	
	Если Параметры.Свойство("НачальноеЗначениеВыбора") Тогда 
		ВыбраннаяСтрока = Неопределено;
		Для Каждого ТекСтрока Из ТаблицаЧасовыхПоясов Цикл 
			Если ТекСтрока.Olson_id = Параметры.НачальноеЗначениеВыбора Тогда 
				ВыбраннаяСтрока = ТекСтрока;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ВыбраннаяСтрока = Неопределено Тогда 
			Элементы.ТаблицаЧасовыхПоясов.ТекущаяСтрока = ВыбраннаяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаЧасовыхПоясов

&НаКлиенте
Процедура ТаблицаЧасовыхПоясовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(ТекущиеДанные.Olson_id);
	
КонецПроцедуры

#КонецОбласти
