#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем
#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	сфпОтчеты.ПриКомпоновкеРезультата(КомпоновщикНастроек, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Метаданные.Документы.Найти("Событие") = Неопределено Тогда
		НайденноеПоле = ЭтотОбъект.СхемаКомпоновкиДанных.НаборыДанных.НаборОтчетПоВсемЗвонкам.Поля.Найти("КоличествоСобытийДень");
		Если НайденноеПоле <> Неопределено Тогда
			ЭтотОбъект.СхемаКомпоновкиДанных.НаборыДанных.НаборОтчетПоВсемЗвонкам.Поля.Удалить(НайденноеПоле);
		КонецЕсли;
		
		ПолеКомпоновки = Новый ПолеКомпоновкиДанных("КоличествоСобытийДень");
		
		Для Каждого ТекЭлемент Из ЭтотОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы Цикл
			Если ТекЭлемент.Поле = ПолеКомпоновки Тогда
				ЭтотОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Выбор.Элементы.Удалить(ТекЭлемент);
				
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ТекЭлемент Из ЭтотОбъект.КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
			Если ТекЭлемент.Поле = ПолеКомпоновки Тогда
				ЭтотОбъект.КомпоновщикНастроек.Настройки.Выбор.Элементы.Удалить(ТекЭлемент);
				
				Прервать;
			КонецЕсли;
		КонецЦикла;

	Иначе
		ТекстЗапроса = ЭтотОбъект.СхемаКомпоновкиДанных.НаборыДанных.НаборОтчетПоВсемЗвонкам.Запрос;
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ЕСТЬСОБЫТИЕ ", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "0 КАК КоличествоСобытийДень,", "//0 КАК КоличествоСобытийДень,");
		ЭтотОбъект.СхемаКомпоновкиДанных.НаборыДанных.НаборОтчетПоВсемЗвонкам.Запрос = ТекстЗапроса;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли