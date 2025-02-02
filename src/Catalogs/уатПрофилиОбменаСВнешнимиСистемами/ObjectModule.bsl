#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.ППР 
		ИЛИ Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.Лукойл
		ИЛИ Ссылка = Справочники.уатПрофилиОбменаСВнешнимиСистемами.Роснефть Тогда
		Возврат;
	КонецЕсли;
	
	НомерСтроки = 1;
	Для Каждого ТекСтрока Из СоответствиеКолонок Цикл
		Если ТипСоответствияКолонок = 0 Тогда
			Если ТекСтрока.Использование 
				И Не ЗначениеЗаполнено(ТекСтрока.ИмяКолонкиФайла) Тогда
				ТекстНСТР = НСтр("ru='Не заполнена колонка ""Имя колонки файла"" в строке %1 списка ""Соответствие колонок""'");
				ТекстСообщения = СтрШаблон(ТекстНСТР, НомерСтроки);
				уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,"СоответствиеКолонок",НомерСтроки, "ИмяКолонкиФайла", Отказ);
			КонецЕсли;
		Иначе
			Если ТекСтрока.Использование 
				И Не ЗначениеЗаполнено(ТекСтрока.НомерКолонкиФайла) Тогда
				ТекстНСТР = НСтр("ru='Не заполнена колонка ""Номер колонки файла"" в строке %1 списка ""Соответствие колонок""'");
				ТекстСообщения = СтрШаблон(ТекстНСТР, НомерСтроки);
				уатОбщегоНазначенияСервер.СообщитьОбОшибке(ЭтотОбъект, ТекстСообщения,"СоответствиеКолонок",НомерСтроки, "НомерКолонкиФайла", Отказ);
			КонецЕсли;
		КонецЕсли;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти