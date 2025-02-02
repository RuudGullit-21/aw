
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
	
	УстановитьЦветаСтатусов();
	
	Если ПолучитьФункциональнуюОпцию("уатРазделятьПланФактВСкладскихАктах_уэ") = Ложь Тогда
		Элементы.КартинкаЕстьРасхождения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

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

Процедура УстановитьЦветаСтатусов()
	
	мсвУдаляемыхЭлементов = Новый Массив();
	Для Каждого ЭлементУсловногоОформления Из Список.УсловноеОформление.Элементы Цикл
		Если ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный" Тогда
			мсвУдаляемыхЭлементов.Добавить(ЭлементУсловногоОформления);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементУсловногоОформления Из мсвУдаляемыхЭлементов Цикл
		Список.УсловноеОформление.Элементы.Удалить(ЭлементУсловногоОформления);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатСтатусы_уэ.Ссылка,
	|	уатСтатусы_уэ.Наименование,
	|	уатСтатусы_уэ.ЦветФонаПоУмолчанию,
	|	уатСтатусы_уэ.ЦветТекстаПоУмолчанию
	|ИЗ
	|	Справочник.уатСтатусы_уэ КАК уатСтатусы_уэ
	|ГДЕ
	|	НЕ уатСтатусы_уэ.ПометкаУдаления
	|	И уатСтатусы_уэ.ДействуетНаАктыПриемки";
	
	ВыборкаЦвета = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаЦвета.Следующий() Цикл 
		ЦветФона   = Неопределено;
		ЦветТекста = Неопределено;
		
		ХранилищеЦветФона = ВыборкаЦвета.ЦветФонаПоУмолчанию;
		Если Не ХранилищеЦветФона = Неопределено Тогда 
			ДанныеЦветФона = ХранилищеЦветФона.Получить();
			Если Не ДанныеЦветФона = Неопределено И ТипЗнч(ДанныеЦветФона) = Тип("Цвет") Тогда
				ЦветФона = ДанныеЦветФона;
			КонецЕсли;
		КонецЕсли;
		
		ХранилищеЦветТекста = ВыборкаЦвета.ЦветТекстаПоУмолчанию;
		Если Не ХранилищеЦветТекста = Неопределено Тогда 
			ДанныеЦветТекста = ХранилищеЦветТекста.Получить();
			Если Не ДанныеЦветТекста = Неопределено И ТипЗнч(ДанныеЦветТекста) = Тип("Цвет") Тогда
				ЦветТекста = ДанныеЦветТекста;
			КонецЕсли;
		КонецЕсли;
		
		Если ЦветТекста = Неопределено И ЦветФона = Неопределено Тогда 
			Продолжить;
		КонецЕсли;
		
		ЭлементУсловногоОформления = Список.УсловноеОформление.Элементы.Добавить();
		
		ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("СтатусВыполнения");
		ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ВыборкаЦвета.Ссылка;
		
		Если Не ЦветТекста = Неопределено Тогда 
			ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветТекста);
		КонецЕсли;
		
		Если Не ЦветФона = Неопределено Тогда 
			ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветФона);
		КонецЕсли;
		
		ЭлементУсловногоОформления.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементУсловногоОформления.ИдентификаторПользовательскойНастройки = "Предустановленный";
		ЭлементУсловногоОформления.Представление = НСтр("en='By status color';ru='По цвету статуса '") + ВыборкаЦвета.Наименование;
		
		ПолеОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеОформления.Поле = Новый ПолеКомпоновкиДанных("СтатусВыполнения");
		ПолеОформления.Использование = Истина;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
