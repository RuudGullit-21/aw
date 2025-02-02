#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Проверка на уникальность реквизита "IDУстройства"
	ПроверитьУникальностьIDУстройства(Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьУникальностьIDУстройства(Отказ)
	
	мЗапрос = Новый Запрос;
	мЗапрос.УстановитьПараметр("IDУстройства", IDУстройства);
	мЗапрос.УстановитьПараметр("Ссылка",       Ссылка);
	
	мЗапрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатМобильныеУстройства.Наименование
	|ИЗ
	|	Справочник.уатМобильныеУстройства КАК уатМобильныеУстройства
	|ГДЕ
	|	уатМобильныеУстройства.IDУстройства = &IDУстройства
	|	И уатМобильныеУстройства.Ссылка <> &Ссылка";
	
	мРезультат = мЗапрос.Выполнить();
	
	Если Не мРезультат.Пустой() Тогда 
		мВыборка = мРезультат.Выбрать();
		Если мВыборка.Следующий() Тогда 
			ТекстНСТР = НСтр("en='This ID is already specified for device';ru='Данный ID уже указан для устройства'") + " """ + мВыборка.Наименование + """.";
		Иначе
			ТекстНСТР = НСтр("en='This ID is already specified for another device';ru='Данный ID уже указан для другого устройства'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,, "Объект.IDУстройства",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли