///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Справочники.ИдентификаторыОбъектовМетаданных.ФормаЭлементаПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ФормаВключитьВозможностьРедактирования.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолноеИмяПриИзменении(Элемент)
	
	ПолноеИмя = Объект.ПолноеИмя;
	ОбновитьСвойстваИдентификатора();
	
	Если ПолноеИмя <> Объект.ПолноеИмя Тогда
		Объект.ПолноеИмя = ПолноеИмя;
		ПоказатьПредупреждение(, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных не найден по полному имени:"
"%1.'; en = 'Metadata object was not found by full name: "
"%1.'"),
			ПолноеИмя));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСвойстваИдентификатора()
	
	Справочники.ИдентификаторыОбъектовМетаданных.ОбновитьСвойстваИдентификатора(Объект);
	
КонецПроцедуры

#КонецОбласти
