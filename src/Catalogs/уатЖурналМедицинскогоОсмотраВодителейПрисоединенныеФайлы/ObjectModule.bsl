
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если уатЖурналыТранспортныхДокументов.ТекущийПользовательМедработник()
		И НЕ Ссылка.ПометкаУдаления И ПометкаУдаления Тогда
		
		ТекстСообщения = "Медицинскому работнику запрещена пометка на удаление присоединенных файлов.";
		уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,,,, Отказ);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти