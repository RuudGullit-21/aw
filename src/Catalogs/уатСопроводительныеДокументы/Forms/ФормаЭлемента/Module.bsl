
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.Взаимодействия
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействия = ОбщегоНазначения.ОбщийМодуль("Взаимодействия");
		МодульВзаимодействия.ПодготовитьОповещения(ЭтотОбъект, Параметры, Ложь);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Объект.Ссылка.Пустая() Тогда
		Если ЗначениеЗаполнено(Объект.Основание) Тогда
			Объект.ДатаДокумента = Объект.Основание.Дата;
		Иначе
			Объект.ДатаДокумента = ТекущаяДата();
		КонецЕсли;
	КонецЕсли;
	
	ПрочитатьПлановуюДатуОбработкиАвто();
	ПрочитатьСтатус();
		                       
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	УстановитьОграничениеТипаОснование();
	УстановитьВидимость();
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПрочитатьСтатус();
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Взаимодействия
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") Тогда
		МодульВзаимодействияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ВзаимодействияКлиент");
		МодульВзаимодействияКлиент.ВзаимодействиеПредметПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи, "уатСопроводительныеДокументы");
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Взаимодействия
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийРеквизитовФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	Объект.ВидВладельца = уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект.ВидДокумента, "ВидВладельца");
	УстановитьВидимость(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПлановаяДатаОбработкиВручнуюПриИзменении(Элемент)
	Если НЕ Объект.ПлановаяДатаОбработкиВручную Тогда
		Объект.ПлановаяДатаОбработки = '00010101';
	КонецЕсли;
	
	ПрочитатьПлановуюДатуОбработкиАвто();
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВладелецДокументаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПриИзменении(Элемент)
	УстановитьОграничениеТипаОснование();
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВидВладельцаПриИзменении(Элемент)
	УстановитьВидимость(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВидОснованияПриИзменении(Элемент)
	УстановитьОграничениеТипаОснование();
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

&НаКлиенте
Процедура НастроитьШаблон(Команда)
	
	ПараметрыФормы = Новый Структура("ОбъектНастройки", "Справочник_уатСопроводительныеДокументы");
	ОткрытьФорму("ОбщаяФорма.уатНастройкаШаблона", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование(Команда)
	
	Объект.Наименование = СформироватьНаименованиеСервер();
	Модифицированность  = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПолучателейУведомлений(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Документ", Объект);
	ПараметрыФормы.Вставить("ВидВладельца", ПредопределенноеЗначение("Перечисление.уатТипыОбъектовДляУведомлений_уэ.СопроводительныйДокумент"));
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПолучателиУведомленийЗакрытиеФормы", ЭтаФорма);
	
	ОткрытьФорму("Документ.уатПотребностьВПеревозке_уэ.Форма.ФормаПолучателейУведомлений",
		ПараметрыФормы,
		ЭтаФорма,,,,
		ОписаниеОповещенияОЗакрытии,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
КонецПроцедуры

&НаКлиенте
Процедура ПолучателиУведомленийЗакрытиеФормы(Результат, ДопПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("ДанныеФормыКоллекция") Тогда
		Объект.ПолучателиУведомлений.Очистить();
		Для Каждого ТекСтрока Из Результат Цикл
			НоваяСтрока = Объект.ПолучателиУведомлений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЦикла;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаСервере
Процедура ПрочитатьСтатус()
	Статус = Неопределено;
	Если Объект.Ссылка.Пустая() Тогда
		Возврат;
	КонецЕсли;
			
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	уатСтатусыСопроводительныхДокументовСрезПоследних.Статус КАК Статус,
	|	уатСтатусыСопроводительныхДокументовСрезПоследних.Местоположение КАК Местоположение,
	|	уатСтатусыСопроводительныхДокументовСрезПоследних.Статус.ЦветТекстаПоУмолчанию КАК ЦветТекста,
	|	уатСтатусыСопроводительныхДокументовСрезПоследних.Статус.ЦветФонаПоУмолчанию КАК ЦветФона
	|ИЗ
	|	РегистрСведений.уатСтатусыСопроводительныхДокументов.СрезПоследних КАК уатСтатусыСопроводительныхДокументовСрезПоследних
	|ГДЕ
	|	уатСтатусыСопроводительныхДокументовСрезПоследних.СопроводительныйДокумент = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Элементы.Статус.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
	Элементы.Статус.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	
	Если Выборка.Следующий() Тогда
		Статус = Выборка.Статус;
		Местоположение = Выборка.Местоположение;
		ЦветТекстаСтатуса = Выборка.ЦветТекста.Получить();
		Если ЦветТекстаСтатуса <> Неопределено Тогда
			Элементы.Статус.ЦветТекста = ЦветТекстаСтатуса;
		КонецЕсли;
		ЦветФонаСтатуса = Выборка.ЦветФона.Получить();
		Если ЦветФонаСтатуса <> Неопределено Тогда
			Элементы.Статус.ЦветФона = ЦветФонаСтатуса;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость(флОчищатьВладельца = Ложь)
	Если Объект.ВидВладельца = ПредопределенноеЗначение("Перечисление.уатВидыВладельцевСопроводительныхДокументов.ДокументыОрганизации") Тогда
		Если флОчищатьВладельца Тогда
			Объект.ВладелецДокумента = Неопределено;
		КонецЕсли;
		Элементы.ВладелецДокумента.Доступность = Ложь;
	Иначе
		Элементы.ВладелецДокумента.Доступность = Истина;
	КонецЕсли;
	
	Элементы.ПлановаяДатаОбработки.Видимость     = Объект.ПлановаяДатаОбработкиВручную;
	Элементы.ПлановаяДатаОбработкиАвто.Видимость = НЕ Объект.ПлановаяДатаОбработкиВручную;
	
	Если Объект.ВидВладельца =
		ПредопределенноеЗначение("Перечисление.уатВидыВладельцевСопроводительныхДокументов.ДокументыОрганизации") Тогда
		
		Элементы.ВладелецДокумента.ПодсказкаВвода = "Наша организация";
		Элементы.ВладелецДокумента.АвтоОтметкаНезаполненного = Ложь;
	ИначеЕсли Объект.ВидВладельца =
		ПредопределенноеЗначение("Перечисление.уатВидыВладельцевСопроводительныхДокументов.ДокументыЗаказчика")
		И НЕ Объект.Шаблон Тогда
		
		Элементы.ВладелецДокумента.ПодсказкаВвода = "";
		Элементы.ВладелецДокумента.АвтоОтметкаНезаполненного = Истина;
	Иначе
		Элементы.ВладелецДокумента.ПодсказкаВвода = "";
		Элементы.ВладелецДокумента.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	Элементы.Шаблон.Видимость = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
	Элементы.ГруппаОбработка.Видимость = НЕ Объект.Шаблон;
	Элементы.Основание.Заголовок = ?(Объект.Шаблон, "Заказ-шаблон", "Основание");
	Элементы.ВидВладельца.Видимость = Объект.Шаблон;
	Элементы.ВидОснования.Видимость = Объект.Шаблон;
	Элементы.ГруппаНомерДата.Видимость = НЕ Объект.Шаблон;
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПлановуюДатуОбработкиАвто()
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	уатДатыОбработкиДокументов.ПлановаяДатаОбработки КАК ПлановаяДатаОбработки
	|ИЗ
	|	РегистрСведений.уатДатыОбработкиДокументов КАК уатДатыОбработкиДокументов
	|ГДЕ
	|	уатДатыОбработкиДокументов.СопроводительныйДокумент = &СопроводительныйДокумент");
	Запрос.УстановитьПараметр("СопроводительныйДокумент", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПлановаяДатаОбработкиАвто = Выборка.ПлановаяДатаОбработки;
	Иначе
		ПлановаяДатаОбработкиАвто = '00010101';
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция СформироватьНаименованиеСервер()
	
	СпрОб = РеквизитФормыВЗначение("Объект");
	Возврат уатНастройкиШаблонов.СформироватьНаименованиеПоШаблону("Справочник_уатСопроводительныеДокументы", СпрОб);
	
КонецФункции

&НаКлиенте
Процедура УстановитьОграничениеТипаОснование()
	Если Объект.Шаблон
		ИЛИ Объект.ВидОснования = ПредопределенноеЗначение("Перечисление.уатВидыОснованийСопроводительныхДокументов.ЗаказНаТС") Тогда
		Элементы.Основание.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.уатЗаказГрузоотправителя");
	ИначеЕсли Объект.ВидОснования = ПредопределенноеЗначение("Перечисление.уатВидыОснованийСопроводительныхДокументов.МаршрутныйЛист") Тогда
		Элементы.Основание.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.уатМаршрутныйЛист");
	Иначе
		Элементы.Основание.ОграничениеТипа = Новый ОписаниеТипов("Неопределено");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
