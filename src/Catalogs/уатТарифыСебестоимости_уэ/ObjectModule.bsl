
#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоГруппа Тогда
		ТекОбластьДействия = ОбластьДействия.Получить();
		Если ТекОбластьДействия <> Неопределено
			И ТипЗнч(ТекОбластьДействия) = Тип("НастройкиКомпоновкиДанных")
			И ТекОбластьДействия.Отбор.Элементы.Количество() > 0 Тогда
			ОбластьДействияПредставление = уатОбщегоНазначенияТиповые.уатПолучитьПредставлениеОтбора(ТекОбластьДействия.Отбор);;
		Иначе
			ОбластьДействияПредставление = "";
		КонецЕсли;
		
		Если ПараметрВыработки = Справочники.уатПараметрыВыработки.СкладскаяОбработка Тогда
			Отказ = Истина;
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Параметр выработки ""Складская обработка"" не предназнаен для использования при расчете себестоимости.';
			|en = 'This output parameter should not be used in cost indicators.'");
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЭтоГруппа Тогда
		Если МетодРасчета = Перечисления.уатМетодыРасчетаПоТарифам.ФиксированнойСуммой
			ИЛИ МетодРасчета = Перечисления.уатМетодыРасчетаПоТарифам.ПоПараметруВыработки Тогда
			ПроверяемыеРеквизиты.Добавить("ПараметрВыработки");
		КонецЕсли;
		
		Если ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоУпаковок Тогда 
			ПроверяемыеРеквизиты.Добавить("ВидУпаковки");
		ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоКонтейнеров Тогда 
			ПроверяемыеРеквизиты.Добавить("ТипКонтейнера");
		ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоТочекПоТипуПункта Тогда 
			ПроверяемыеРеквизиты.Добавить("ТипПункта");
		ИначеЕсли ПараметрВыработки = Справочники.уатПараметрыВыработки.КоличествоТочекПоВидуОперации Тогда 
			ПроверяемыеРеквизиты.Добавить("ТипТочкиМаршрута");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти