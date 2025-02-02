
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа
		И ТипТС.Самосвал И НЕ ЗначениеЗаполнено(НормируемаяЗагрузкаСамосвала) Тогда
		ТекстНСТР = НСтр("en='For model vehicle of type ""Dump truck"" it is necessary to specify the load factor of the truck.';ru='Для модели ТС типа ""Самосвал"" необходимо указать коэффициент загрузки самосвала.'");
		уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстНСТР ,,, "НормируемаяЗагрузкаСамосвала", Отказ);
	КонецЕсли;
	
	Если НЕ ЭтоГруппа
		И МинимальноеКоличествоУпаковок > МаксимальноеКоличествоУпаковок Тогда 
		ТекстНСТР = НСтр("en='Maximum number of packages may not be less than the minimum.';ru='Максимальное количество упаковок не может быть меньше минимального.'");
		уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстНСТР ,,, "МаксимальноеКоличествоУпаковок", Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти