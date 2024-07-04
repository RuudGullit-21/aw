#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	УстановитьЦветаСтатусов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
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
	|	И уатСтатусы_уэ.ДействуетНаОперацииСГрузами";
	
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
