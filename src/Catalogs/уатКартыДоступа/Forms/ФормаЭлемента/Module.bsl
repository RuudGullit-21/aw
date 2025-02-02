
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	//ПодключаемоеОборудование
	уатОбщегоНазначения_проф.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	//Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	
	//ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект);
	
	//Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование"
		И ВводДоступен()
		Тогда
		
		Если ИмяСобытия = "ScanData" Тогда
			ОбработатьШтрихкод(Параметр);
		ИначеЕсли ИмяСобытия = "TracksData" Тогда
			ОбработатьМагнитныйКод(Параметр);
		ИначеЕсли ИмяСобытия = "RFID" Тогда
			ОбработатьКодRFID(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	// ПодключаемоеОборудование
	уатОбщегоНазначенияКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьШК(Команда)
	Отказ = Ложь;
	уатОбщегоНазначенияКлиент.ПроверитьЗаписьНовогоОбъектаВФорме(ЭтотОбъект, Объект.Ссылка,,, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Штрихкод = уатЗащищенныеФункцииСервер_проф.СформироватьШтрихкодОбъекта(Объект.Ссылка);
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьШтрихкод(Данные)
	
	Штрихкод = уатОбщегоНазначенияКлиент.ПолучитьШтрихкодПоДаннымСобытия(Данные);
	Если Штрихкод <> "" Тогда
		Объект.Штрихкод = Штрихкод;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьМагнитныйКод(Данные)
	
	МагнитныйКод = уатОбщегоНазначенияКлиент.ПолучитьМагнитныйКодПоДаннымСобытия(Данные);
	Если МагнитныйКод <> "" Тогда
		Объект.МагнитныйКод = МагнитныйКод;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьКодRFID(Данные)
	
	КодRFID = уатОбщегоНазначенияКлиент.ПолучитьRFIDКодПоДаннымСобытия(Данные);
	Если КодRFID <> "" Тогда
		Объект.КодRFID = КодRFID;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти