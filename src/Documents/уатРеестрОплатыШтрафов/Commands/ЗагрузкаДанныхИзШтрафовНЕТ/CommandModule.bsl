
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Обработчик = Новый ОписаниеОповещения("ЗагрузитьРеестрыЗавершение", ЭтотОбъект);
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Заголовок", Нстр("ru = 'Выберите учетную запись'"));
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("ВнешняяСистема",
		ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ШтрафовНет")));
	ОткрытьФорму("Справочник.уатУчетныеЗаписиСервисовШтрафов.ФормаВыбора", ПараметрыОткрытияФормы, ПараметрыВыполненияКоманды.Источник,,,,Обработчик);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьРеестрыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Загружено   = 0;
	НеЗагружено = 0;
	ЗагрузитьРеестрыЗавершениеСервер(Результат, Загружено, НеЗагружено);
	
	Если Загружено = 0 Тогда
		ТекстСообщения = НСтр("ru='Загрузка реестров завершена.';en='Download is complete.'");
	Иначе
		ТекстСообщения = НСтр("ru='Загрузка реестров выполнена успешно.'");
	КонецЕсли;
	
	Если Загружено > 0 
		ИЛИ НеЗагружено > 0 Тогда
		ТекстСообщения = ТекстСообщения + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Загружено новых: %1.';en='Imported new: %1.'"), Загружено);
		Если НеЗагружено > 0 Тогда
			ТекстСообщения = ТекстСообщения + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не загружено: %1.';en='Imported new: %1.'"), НеЗагружено);
		КонецЕсли;
	Иначе
		ТекстСообщения = ТекстСообщения + Символы.ПС + НСтр("ru='Изменений нет.';en='There are no changes.'");
	КонецЕсли;

	ПоказатьОповещениеПользователя(НСтр("ru='Загрузка реестров.'"),,ТекстСообщения);
	ОповеститьОбИзменении(Тип("ДокументСсылка.уатРеестрОплатыШтрафов"));

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьРеестрыЗавершениеСервер(УчетнаяЗапись, Загружено = 0, НеЗагружено = 0)
	
	ТекстОшибки = "";
	ТабРеестров = уатИнтеграции_проф.ШтрафовНет_СписокРеестров(УчетнаяЗапись, ТекстОшибки);
	Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
		Для Каждого ТекРеестр Из ТабРеестров Цикл
			флШтрафыПустые = Истина;
			уатИнтеграции_проф.СоздатьРеестр(УчетнаяЗапись, ТекРеестр, флШтрафыПустые);
			
			Если флШтрафыПустые Тогда
				НеЗагружено = НеЗагружено + 1;
			Иначе
				Загружено = Загружено + 1;
			КонецЕсли;
		КонецЦикла;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти