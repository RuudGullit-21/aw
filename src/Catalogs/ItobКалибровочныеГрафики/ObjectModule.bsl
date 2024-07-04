#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	// Контроль полноты графика
	
	Если Показатели.Количество() < 2 Тогда
		Отказ = Истина;
		ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'В таблице преобразования должно быть как минимум две строки!'"));		
	КонецЕсли;
	
	// Контроль дублирования строк	
	
	ТЗКонтроль = Показатели.Выгрузить();
	ТЗКонтроль.Колонки.Добавить("Количество");
	ТЗКонтроль.ЗаполнитьЗначения(1,"Количество");
	ТЗКонтроль.Свернуть("Вход,Выход", "Количество");
	
	Для Каждого СтрокаТЗ Из ТЗКонтроль Цикл
		Если СтрокаТЗ.Количество > 1 Тогда
			Отказ = Истина;
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'В таблице преобразования дублируются одинаковые строки!'"));	
		
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#КонецЕсли
