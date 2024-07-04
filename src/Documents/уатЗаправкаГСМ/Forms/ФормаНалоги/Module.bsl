#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере формы.
// В процедуре осуществляется
// - инициализация параметров формы.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПолучитьЗначенияПараметровФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
// Процедура - обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьСуммаВключаетНДС();
КонецПроцедуры // ПриОткрытии()

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик события нажатия кнопки ОК.
//
Процедура КомандаОК(Команда)
	
	Отказ = Ложь;
	
	ПроверитьЗаполнениеРеквизитовФормы(Отказ);
	ПроверитьМодифицированностьФормы();
  
	Если НЕ Отказ Тогда
		СтруктураРеквизитовФормы = Новый Структура;
        СтруктураРеквизитовФормы.Вставить("БылиВнесеныИзменения", 			БылиВнесеныИзменения);
  		СтруктураРеквизитовФормы.Вставить("НалогообложениеНДС",				НалогообложениеНДС);
		СтруктураРеквизитовФормы.Вставить("СуммаВключаетНДС", 				СуммаВключаетНДС);
		//СтруктураРеквизитовФормы.Вставить("НДСВключатьВСтоимость", 			НДСВключатьВСтоимость);
		СтруктураРеквизитовФормы.Вставить("ПредНалогообложениеНДС", 		НалогообложениеНДСПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ПредСуммаВключаетНДС", 			СуммаВключаетНДСПриОткрытии);
		СтруктураРеквизитовФормы.Вставить("ИмяФормы", 						"ФормаНалоги");
		Закрыть(СтруктураРеквизитовФормы);
	КонецЕсли;

КонецПроцедуры // КомандаОК()

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	УстановитьВидимостьСуммаВключаетНДС()
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура заполняет параметры формы.
//
Процедура ПолучитьЗначенияПараметровФормы()
	
	// Налогообложение НДС.
	Если Параметры.Свойство("НалогообложениеНДС") Тогда
		НалогообложениеНДС = Параметры.НалогообложениеНДС;
		НалогообложениеНДСПриОткрытии = Параметры.НалогообложениеНДС;
		НалогообложениеНДСЕстьРеквизит = Истина;
	Иначе
		Элементы.НалогообложениеНДС.Видимость = Ложь;
		НалогообложениеНДСЕстьРеквизит = Ложь;
	КонецЕсли;
	
	// Сумма включает НДС.
	Если Параметры.Свойство("СуммаВключаетНДС") Тогда
		СуммаВключаетНДС = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСПриОткрытии = Параметры.СуммаВключаетНДС;
		СуммаВключаетНДСЕстьРеквизит = Истина;
	Иначе
		Элементы.СуммаВключаетНДС.Видимость = Ложь;
		СуммаВключаетНДСЕстьРеквизит = Ложь;
	КонецЕсли;	
	
	//// НДС включать в стоимость.
	//Если Параметры.Свойство("НДСВключатьВСтоимость") Тогда
	//	
	//	НДСВключатьВСтоимость = Параметры.НДСВключатьВСтоимость;
	//	НДСВключатьВСтоимостьПриОткрытии = Параметры.НДСВключатьВСтоимость;
	//	НДСВключатьВСтоимостьЕстьРеквизит = Истина;
	//	
	//Иначе
	//	
	//	Элементы.НДСВключатьВСтоимость.Видимость = Ложь;
	//	НДСВключатьВСтоимостьЕстьРеквизит = Ложь;
	//	
	//КонецЕсли;
КонецПроцедуры // ПолучитьЗначенияПараметровФормы()

&НаКлиенте
// Процедура проверяет правильность заполнения реквизитов формы.
//
Процедура ПроверитьЗаполнениеРеквизитовФормы(Отказ)
	
	// Налогообложение НДС.
	Если НалогообложениеНДСЕстьРеквизит Тогда
		Если НЕ ЗначениеЗаполнено(НалогообложениеНДС) Тогда
            ТекстНСТР = НСтр("en='Not filled taxation';ru='Не заполнено налогообложение'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР,, "НалогообложениеНДС",, Отказ);
   		КонецЕсли;
	КонецЕсли;
КонецПроцедуры // ПроверитьЗаполнениеРеквизитовФормы()

&НаКлиенте
// Процедура проверяет модифицированность формы.
//
Процедура ПроверитьМодифицированностьФормы()

	БылиВнесеныИзменения = Ложь;
	ИзмененияНалогообложениеНДС 	= ?(НалогообложениеНДСЕстьРеквизит, 
	НалогообложениеНДСПриОткрытии <> НалогообложениеНДС, Ложь);
	ИзмененияСуммаВключаетНДС 		= ?(СуммаВключаетНДСЕстьРеквизит, СуммаВключаетНДСПриОткрытии <> СуммаВключаетНДС, Ложь);
	//ИзмененияНДСВключатьВСтоимость 	= ?(НДСВключатьВСтоимостьЕстьРеквизит, 
	//НДСВключатьВСтоимостьПриОткрытии <> НДСВключатьВСтоимость, Ложь);
	
	Если  ИзмененияНалогообложениеНДС
		ИЛИ ИзмененияСуммаВключаетНДС
		//ИЛИ ИзмененияНДСВключатьВСтоимость
		Тогда
		БылиВнесеныИзменения = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПроверитьМодифицированностьФормы()

&НаСервере
// Процедура заполнения курса и кратности валюты документа.
//
Процедура УстановитьВидимостьСуммаВключаетНДС()
	Элементы.СуммаВключаетНДС.Видимость = НалогообложениеНДС;
КонецПроцедуры

#КонецОбласти
