
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если Запись.Пункт1.ЭтоГруппа или Запись.Пункт2.ЭтоГруппа Тогда
			Отказ = Истина;
			СтрокаОтказа = НСтр("en='You can not use a group as a destination.';ru='Нельзя использовать в качестве пункта назначения - группу.'");
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаОтказа);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти