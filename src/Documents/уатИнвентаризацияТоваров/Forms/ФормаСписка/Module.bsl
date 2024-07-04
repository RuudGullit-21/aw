
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
    ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//ПодключаемоеОборудование
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		ОМ_уатОбщегоНазначения_проф = ОбщегоНазначения.ОбщийМодуль("уатОбщегоНазначения_проф");
		ОМ_уатОбщегоНазначения_проф.НастроитьПодключаемоеОборудование(ЭтотОбъект);
	КонецЕсли;
	//Конец ПодключаемоеОборудование
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Документы.уатИнвентаризацияТоваров) Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	флАдресноеХранение = ПолучитьФункциональнуюОпцию("уатАдресноеХранение") = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	//ПодключаемоеОборудование
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		уатОбщегоНазначенияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтотОбъект);
	КонецЕсли;
	//Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД()
		И Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		уатОбщегоНазначенияКлиент.ОбработатьСобытиеПодключаемогоОборудования(ИмяСобытия, Параметр, Источник);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	// ПодключаемоеОборудование
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		уатОбщегоНазначенияКлиент.ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииВнутреннееПеремещениеИзвлечение(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание, ВидОперации", ТекСтрока.Ссылка,
		ПредопределенноеЗначение("Перечисление.уатВидыОперацийВнутреннееПеремещение.ИзвлечениеИзЯчейки"));
	ОткрытьФорму("Документ.уатВнутреннееПеремещение.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииВнутреннееПеремещениеРазмещение(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Основание, ВидОперации", ТекСтрока.Ссылка,
		ПредопределенноеЗначение("Перечисление.уатВидыОперацийВнутреннееПеремещение.РазмещениеВЯчейке"));
	ОткрытьФорму("Документ.уатВнутреннееПеремещение.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ПакетноеСписание(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьНаОснованииВнутреннееПеремещениеИзвлечение(Неопределено);
	
	ПараметрыФормы = Новый Структура("Основание", ТекСтрока.Ссылка);
	ОткрытьФорму("Документ.уатСписаниеТоваров.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура УстановитьВидимость()

	флВидимостьОперацииСЯчеистымСкладом = Ложь;
	
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока <> Неопределено И флАдресноеХранение 
		И уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТекСтрока.Склад, "АдресноеХранение") Тогда
		флВидимостьОперацииСЯчеистымСкладом = Истина;
	КонецЕсли;
	
	Элементы.ФормаСоздатьНаОснованииВнутреннееПеремещениеИзвлечение.Видимость = флВидимостьОперацииСЯчеистымСкладом;
	Элементы.ФормаСоздатьНаОснованииВнутреннееПеремещениеРазмещение.Видимость = флВидимостьОперацииСЯчеистымСкладом;
	Элементы.ФормаПакетноеСписание.Видимость = флВидимостьОперацииСЯчеистымСкладом;
		
КонецПроцедуры

#КонецОбласти
