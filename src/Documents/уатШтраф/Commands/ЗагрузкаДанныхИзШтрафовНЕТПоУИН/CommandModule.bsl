
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	Обработчик = Новый ОписаниеОповещения("ЗагрузитьШтрафыЗавершение", ЭтотОбъект);
	ПараметрыОткрытияФормы = Новый Структура();
	ПараметрыОткрытияФормы.Вставить("Заголовок", Нстр("ru = 'Выберите учетную запись'"));
	ПараметрыОткрытияФормы.Вставить("Отбор", Новый Структура("ВнешняяСистема",
	ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ШтрафовНет")));
	ОткрытьФорму("Справочник.уатУчетныеЗаписиСервисовШтрафов.ФормаВыбора", ПараметрыОткрытияФормы, ПараметрыВыполненияКоманды.Источник,,,,Обработчик);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьШтрафыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжение", ЭтотОбъект, Результат);
	ТекстСообщения = НСтр("ru='Введите УИН штрафа'");
	ПоказатьВводСтроки(ОписаниеОповещения,, ТекстСообщения, 150);

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжение(Номер, УчетнаяЗапись) Экспорт
	
	ОшибкаЗаполнения = Ложь;
	Если НЕ ЗначениеЗаполнено(Номер) Тогда 
		ТекстОшибки = НСтр("ru='Необходимо указать УИН штрафа.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, ОшибкаЗаполнения);
	КонецЕсли;
	
	Если ОшибкаЗаполнения Тогда 
		Возврат;
	КонецЕсли;
	
	ШтрафСсылка = Неопределено;
	ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжениеСервер(Номер, УчетнаяЗапись, ШтрафСсылка);
	
	Если ЗначениеЗаполнено(ШтрафСсылка) Тогда
		ТекстВопроса = НСтр("ru='Штраф по УИН ""%1"" уже существует в базе. При нажатии на кнопку ОК будет открыта его форма.'");
		ТекстВопроса = СтрШаблон(ТекстВопроса, Номер);
		ПоказатьВопрос(
		Новый ОписаниеОповещения("ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжениеШтрафСуществует", ЭтотОбъект, ШтрафСсылка),
		ТекстВопроса,
		РежимДиалогаВопрос.ОКОтмена);
	КонецЕсли;

	ОповеститьОбИзменении(Тип("ДокументСсылка.уатШтраф"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжениеШтрафСуществует(РезультатВопроса, ШтрафСсылка) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.ОК Тогда 
		
		ОткрытьФорму("Документ.уатШтраф.ФормаОбъекта", Новый Структура("Ключ", ШтрафСсылка));
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузкаДанныхИзШтрафовНЕТПоУИНПродолжениеСервер(Номер, УчетнаяЗапись, ШтрафСсылка = Неопределено)
	
	ПараметрыЗапроса = Новый Структура();
	ПараметрыЗапроса.Вставить("UIN", СтрЗаменить(Номер, " ", ""));
	
	ТекстОшибки = "";
	
	СписокШтрафов = уатИнтеграцияШтрафовНет.ШтрафовНет_ВыполнитьЗапросДанных(УчетнаяЗапись, "fines_info", ТекстОшибки, ПараметрыЗапроса);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	СоответствиеТС = уатИнтеграции_проф.ЗаполнитьСоответствиеТСвСервисеШтрафов(УчетнаяЗапись);
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;

	МассивШтрафов = СписокШтрафов.Получить("fines");
	
	МассивПостановлений           = Новый Массив();
	МассивОплаченныхПостановлений = Новый Массив();

	Если ТипЗнч(МассивШтрафов) = Тип("Массив")
		И МассивШтрафов.Количество() > 0 Тогда
		
		СтруктураШтрафа = уатИнтеграции_проф.ЗаполнитьСтруктураШтрафа(МассивШтрафов[0], УчетнаяЗапись, СоответствиеТС);
		Если ЗначениеЗаполнено(СтруктураШтрафа.ТС) Тогда
			ПринадлежностьШтрафа = Перечисления.уатПринадлежностьШтрафов.Машина;
		Иначе
			ПринадлежностьШтрафа = Перечисления.уатПринадлежностьШтрафов.МашинаНеизвестная;
		КонецЕсли;
		СтруктураШтрафа.Вставить("ПринадлежностьШтрафа", ПринадлежностьШтрафа);
		
		МассивШтрафов = Новый Массив();
		МассивШтрафов.Добавить(СтруктураШтрафа);
		МассивПостановлений.Добавить(СтруктураШтрафа.НомерПостановления);
		
		Если СтруктураШтрафа.ТекущиеСостояниеОплатыПостановления = Перечисления.уатСтатусыПлатежейШтрафов.paid
			ИЛИ СтруктураШтрафа.ТекущиеСостояниеОплатыПостановления = Перечисления.уатСтатусыПлатежейШтрафов.partpaid
			ИЛИ СтруктураШтрафа.ТекущиеСостояниеОплатыПостановления = Перечисления.уатСтатусыПлатежейШтрафов.overpaid
			ИЛИ СтруктураШтрафа.ТекущиеСостояниеОплатыПостановления = Перечисления.уатСтатусыПлатежейШтрафов.prepaid Тогда
			МассивОплаченныхПостановлений.Добавить(СтруктураШтрафа.НомерПостановления);
		КонецЕсли;
	Иначе
		ТекстОшибки = СтрШаблон(НСтр("ru='Штраф ""%1"" не найден в сервисе.'"), СтрЗаменить(Номер, " ", ""));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("НомерПостановления", СтруктураШтрафа.НомерПостановления);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	уатШтраф.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.уатШтраф КАК уатШтраф
	               |ГДЕ
	               |	уатШтраф.НомерПостановления = &НомерПостановления
	               |	И НЕ уатШтраф.ПометкаУдаления";

	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ШтрафСсылка = Выборка.Ссылка;
		Возврат;
	Конецесли;
	
	ТекстЛога           = "";
	Для Каждого ТекШтраф Из МассивШтрафов Цикл
		
		СоответсвиеОплатыШтрафов = уатИнтеграции_проф.ШтрафовНет_ПолучитьДанныеОплаты(УчетнаяЗапись, МассивОплаченныхПостановлений);
		СоответсвиеШтрафов       = Новый Соответствие;
		
		уатИнтеграции_проф.СоздатьОбновитьШтраф(УчетнаяЗапись, Ложь, ТекШтраф, СоответсвиеШтрафов, СоответсвиеОплатыШтрафов, ТекстЛога);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти