
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Запись.ИсходныйКлючЗаписи.Пустой() Тогда
	
		
		СоотвДанныеДатчиков = ItobОбщегоНазначения.ПреобразоватьСтрокуВДанныеДатчиков(Запись.ДанныеДатчиков);
		Для каждого ЭлементСоответствия Из СоотвДанныеДатчиков Цикл
			НовСтрока = ТабДатчики.Добавить();
			НовСтрока.КодДатчика = ЭлементСоответствия.Ключ;
			НовСтрока.Значение   = ЭлементСоответствия.Значение;
				
		КонецЦикла;
			
		ТабДатчики.Сортировать("КодДатчика Возр");			
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Период = '00010101' Тогда
		ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан период'; en = 'Period is not specified'"));
		Отказ = Истина;
	
	КонецЕсли;
	
	Если ТекущийОбъект.Терминал.Пустая() Тогда
		ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Не указан терминал'"));
		Отказ = Истина;
	
	КонецЕсли;
	
	СоотвДанныеДатчиков = Новый Соответствие;
	Для каждого СтрокаТаб Из ТабДатчики Цикл
		
		Если СтрокаТаб.КодДатчика = 0 Тогда
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Код датчика должен быть больше нуля'"));
			Отказ = Истина;
		
		КонецЕсли;
		
		Если СтрокаТаб.КодДатчика > 255 Тогда
			ItobРаботаС_БСП_КлиентСервер.СообщитьПользователю(НСтр("ru = 'Код датчика должен меньше 256'"));
			Отказ = Истина;
		
		КонецЕсли;
		
		СоотвДанныеДатчиков.Вставить(СтрокаТаб.КодДатчика, СтрокаТаб.Значение);	                
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат;		
	
	КонецЕсли;
	
	ТекущийОбъект.ДанныеДатчиков = ItobОбщегоНазначенияКлиентСервер.ПреобразоватьДанныеДатчиковВСтроку(СоотвДанныеДатчиков);
		
КонецПроцедуры
	
#КонецОбласти 
