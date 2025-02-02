
#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.АвтоМасштаб = Истина;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПараметрПоВалютеОтчета = Новый ПараметрКомпоновкиДанных("ПоВалютеОтчета");
	ПоВалютеОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрПоВалютеОтчета).Значение;
	Если ПоВалютеОтчета Тогда
		Идентификатор = КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьИдентификаторПоОбъекту(КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВалютаОтчета")));
		ВалютаОтчета  = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(Идентификатор).Значение;
	КонецЕсли;
	
	Если ПоВалютеОтчета И Не ЗначениеЗаполнено(ВалютаОтчета) Тогда
		ТекстОшибки = НСтр("en='Not specified report currency.';ru='Не указана валюта отчета.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
