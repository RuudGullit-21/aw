&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	                                                           
	ОбменСГИСЭПД.ПриСозданииНаСервереПодчиненнойФормы(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ФормаБезОбработки") = Ложь И ЭтотОбъект.ЗапретитьИзменение = Ложь Тогда
		Элементы.СсылкаВалютаШтрафа.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Валюты");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
		
	ОбменСГИСЭПДКлиент.СохранитьПараметрыПодчиненнойФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбменСГИСЭПДКлиент.ПриОткрытииПодчиненнойФормы(ЭтотОбъект);
																		
КонецПроцедуры
			
&НаКлиенте
Функция ОписаниеРеквизитовФормы() Экспорт
	
	Возврат ОписаниеРеквизитовФормыСервер();
	
КонецФункции

&НаСервере
Функция ОписаниеРеквизитовФормыСервер()
	
	Возврат ОбменСГИСЭПД.ОписаниеРеквизитовФормы(ЭтаФорма);
		
КонецФункции

&НаКлиенте
Процедура ТитулФрахтователяПодачаРасчетИРазмерШтрафаПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОбменСГИСЭПДКлиент.ОчиститьПодчиненныеТаблицы(ЭтотОбъект, Элемент.Имя, ТекущиеДанные.ИдентификаторСтроки, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СсылкаВалютаШтрафаПриИзменении(Элемент)
	
	ОбменСГИСЭПДКлиентСервер.ЗаполнитьРеквизитыПоСсылке(Элемент, ЭтотОбъект, Элементы.ТитулФрахтователяПодачаРасчетИРазмерШтрафа.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТитулФрахтователяПодачаРасчетИРазмерШтрафаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	ОбменСГИСЭПДКлиент.ТаблицаПриНачалеРедактирования(Элемент, ЭтотОбъект, НоваяСтрока, Копирование);

КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтметитьОбязательныеНеЗаполненныеЭлементыФормы" Тогда
		Если УникальныйИдентификатор <> Параметр Тогда
			Возврат;
		КонецЕсли;
		ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр);
	ИначеЕсли ИмяСобытия = "ИзменитьОформлениеКнопокФормы" Тогда
		Если УникальныйИдентификатор <> Параметр.УникальныйИдентификаторОбновляемойФормы Тогда
			Возврат;
		КонецЕсли;
		ИзменитьОформлениеКнопок(Параметр);	 
	КонецЕсли;
	
КонецПроцедуры

#Область ОбъектыОбязательныеДляЗаполнения

&НаКлиенте
Процедура ИзменитьОформлениеКнопок(Параметр) Экспорт

	Если Не ЭтотОбъект.НачальноеОформлениеВыполнено Тогда
		ЭтотОбъект.ТребуетсяДополнительноеОформлениеКнопок = Истина;
		Если ЭтотОбъект.СтруктураДополнительногоОформленияКнопок <> Неопределено Тогда
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = 
				Новый ФиксированнаяСтруктура("ИмяКнопки, ИдентификаторСтроки");
		Иначе
			ЭтотОбъект.СтруктураДополнительногоОформленияКнопок = Параметр;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	СтруктураДанныхОбъекта = ОбменСГИСЭПДКлиентСервер.ПолучитьСериализуемыйОбъектСДаннымиДокумента(ЭтотОбъект);
	СтруктураСДаннымиФормыДляОформленияКнопок = 
		ОбменСГИСЭПДКлиентСервер.СтруктураСДаннымиФормыДляОформленияКнопок(ЭтотОбъект);
	
	Результат = ИзменитьОформлениеКнопокНаСервере(СтруктураСТекущимиДаннымиРеквизитов,
		Параметр.ИмяКнопки,
		Параметр.ИдентификаторСтроки,
		СтруктураДанныхОбъекта,
		СтруктураСДаннымиФормыДляОформленияКнопок);
		
	Если Результат.Успешно Тогда
		ЭтотОбъект.АдресДереваСоответствийИтаблицыКнопок = Результат.НовыйАдресВХранилище;	
		МассивОформления = Результат.МассивОформления;
		ОбменСГИСЭПДКлиентСервер.ОформлениеКнопокНаФорме(ЭтотОбъект,
			СтруктураСТекущимиДаннымиРеквизитов, МассивОформления);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменитьОформлениеКнопокНаСервере(Знач СтруктураСТекущимиДаннымиРеквизитов,
	ИмяКнопки = Неопределено,
	ИдентификаторСтроки = Неопределено,
	Знач СтруктураДанныхОбъекта,
	Знач СтруктураСДаннымиФормыДляОформленияКнопок)
	
	НовыйАдресВХранилище = ОбменСГИСЭПД.ЗапуститьИзменениеОформленияКнопок(СтруктураСДаннымиФормыДляОформленияКнопок,
		СтруктураСТекущимиДаннымиРеквизитов, ИмяКнопки, ИдентификаторСтроки, СтруктураДанныхОбъекта);

	Результат = ОбменСГИСЭПД.ОбработатьРезультатИзмененияОформленияКнопок(НовыйАдресВХранилище);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(Параметр)
	
	СтруктураСТекущимиДаннымиРеквизитов = ОбменСГИСЭПДКлиентСервер.ПолучитьСтруктуруПоТитулуИВерсии(ЭтотОбъект);
	ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(СтруктураСТекущимиДаннымиРеквизитов);
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьОбязательныеНеЗаполненныеЭлементыФормыНаСервере(Знач СтруктураСТекущимиДанными)
	
	ОбменСГИСЭПД.ОтметитьОбязательныеНеЗаполненныеЭлементыФормы(ЭтотОбъект, СтруктураСТекущимиДанными);
	
КонецПроцедуры

#КонецОбласти