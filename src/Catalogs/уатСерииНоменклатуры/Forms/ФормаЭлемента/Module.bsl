
#Область ПеременныеФормы

&НаКлиенте
Перем НеобходимоЗаписать;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если Объект.Ссылка.Пустая() Тогда
		Элементы.ОткрытьОтчетПробегИзносШин.Видимость = Ложь;
		Если Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
			Объект.Валюта = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
	КонецЕсли;
	
	НаименованиеПоШаблону = СформироватьНаименованиеСервер();

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
	
	УстановитьВидимостьИДоступностьЭлементовФормы();
	Если (Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина")) 
			И (Не Объект.Ссылка.Пустая()) Тогда
		ОбщийПробег = ПолучитьПробегШины(Объект.Ссылка);
	КонецЕСли;
	
	Если Объект.ДатаПроизводстваШины <> Дата(1,1,1) Тогда
		ДатаПроизводстваШиныСтрока = Формат(НеделяГода(Объект.ДатаПроизводстваШины), "ЧЦ=2; ЧВН=") + Формат(Объект.ДатаПроизводстваШины, "ДФ=yy");
	КонецЕсли;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ЗначениеЗаполнено(Объект.СерийныйНомер) тогда
		Если НеобходимоЗаписать = Неопределено Тогда
			РезЗапроса = ПроверкаУникальностиСерийногоНомера();
			Если РезЗапроса.Количество() > 0 тогда
				ТекстНСТР = НСтр("en='In the system there are already car parts with the specified serial number (%1). Continue?';ru='В системе уже имеются агрегаты с указанным серийным номером (%1). Продолжить?'");
				ТекстСообщения = СтрШаблон(ТекстНСТР, Объект.СерийныйНомер);
				Для Каждого ТекАгрегат Из РезЗапроса Цикл
					ТекстСообщения = ТекстСообщения + Символы.ПС + " " + ТекАгрегат;
				КонецЦикла;
				Ответ = Неопределено;
				Отказ = Истина;
				ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюЗавершение", ЭтотОбъект), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет, НСтр("en='Car part record';ru='Запись агрегата'"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не Объект.ЭтоГруппа Тогда
		Если ЗначениеЗаполнено(Объект.Наименование)
			И Объект.Наименование = НаименованиеПоШаблону 
			И НЕ ВопросСформироватьНаименование Тогда
			
			НовоеНаименование              = СформироватьНаименованиеСервер();
			Если НовоеНаименование <> НаименованиеПоШаблону Тогда
				ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗаписьюШаблонНаименованияЗавершение", ЭтотОбъект, НовоеНаименование), "Измененить наименование на новое по шаблону?",
				РежимДиалогаВопрос.ДаНет,60,КодВозвратаДиалога.Нет);
			Иначе
				ВопросСформироватьНаименование = Истина;
			КонецЕсли;
		ИначеЕсли Не ЗначениеЗаполнено(Объект.Наименование) Тогда
			Объект.Наименование = СформироватьНаименованиеСервер();
			Модифицированность             = Истина;
			ВопросСформироватьНаименование = Истина;
		КонецЕсли;
	Иначе
		ВопросСформироватьНаименование = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписьюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да тогда
		НеобходимоЗаписать = Истина;
		Если Не Объект.ЭтоГруппа И Не ЗначениеЗаполнено(Объект.Наименование) Тогда
			СформироватьНаименованиеСервер();
		КонецЕсли;
		Записать();
	КонецЕсли;
	
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если НЕ ВопросСформироватьНаименование 
		И ЗначениеЗаполнено(Объект.Наименование)
		И Объект.Наименование = НаименованиеПоШаблону Тогда
		СтандартнаяОбработка			 = Ложь;
		ЗавершениеРаботы				 = Ложь;
		Отказ							 = Истина;
		ВопросСформироватьНаименование	 = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипАгрегатаПриИзменении(Элемент)
	
	УстановитьВидимостьИДоступностьЭлементовФормы();
	ПриИзмененииТипаАгрегатаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура МодельПриИзменении(Элемент)
	
	ПриИзмененииМоделиНаСервере();
	УстановитьВидимостьИДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
КонецПроцедуры

&НаКлиенте
Процедура ДатаПроизводстваШиныСтрокаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДатаПроизводства = ?(ЗначениеЗаполнено(Объект.ДатаПроизводстваШины), Объект.ДатаПроизводстваШины, ТекущаяДата());
	Подсказка  = НСтр("en='The production date of the tire:';ru='Дата производства шины:'");
	ЧастьДаты  = ЧастиДаты.Дата;
	Оповещение = Новый ОписаниеОповещения("ОбработкаВыбораДатаПроизводстваШины", ЭтотОбъект);
	ПоказатьВводДаты(Оповещение, ДатаПроизводства, Подсказка, ЧастьДаты);
КонецПроцедуры

&НаКлиенте
Процедура ДатаПроизводстваШиныСтрокаПриИзменении(Элемент)
	ГодПроизводства    = СокрЛП(Прав(ДатаПроизводстваШиныСтрока, 2));
	НеделяПроизводства = СокрЛП(Лев(ДатаПроизводстваШиныСтрока, 2));
	
	
	Если ((НЕ ЗначениеЗаполнено(ГодПроизводства) ИЛИ ГодПроизводства = "0")
		И (НЕ ЗначениеЗаполнено(НеделяПроизводства) ИЛИ НеделяПроизводства = "0" ИЛИ НеделяПроизводства = "00")) Тогда
		Объект.ДатаПроизводстваШины = Дата(1,1,1);
		ДатаПроизводстваШиныСтрока  = "";
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ГодПроизводства) Тогда
		ГодПроизводства = Число(ГодПроизводства);
		ТекДата         = Число(Формат(ТекущаяДата(), "ДФ=yy"));
		ТекДатаГод      = Число(Лев(Формат(ТекущаяДата(), "ДФ=yyyy"), 2));
		ГодПроизводстваСтрока = Формат(ГодПроизводства, "ЧЦ=2; ЧВН=");
		Если НЕ ЗначениеЗаполнено(ГодПроизводстваСтрока) Тогда
			ГодПроизводстваСтрока = "00";
		КонецЕсли;
		Если ГодПроизводства < ТекДата + 10 Тогда
			ГодПроизводства = Строка(ТекДатаГод) + ГодПроизводстваСтрока;
			Иначе
			ГодПроизводства = Строка(ТекДатаГод -1) + ГодПроизводстваСтрока;
		КонецЕсли;
		ГодПроизводства = Число(ГодПроизводства);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НеделяПроизводства) 
		И НеделяПроизводства <> "0" И НеделяПроизводства <> "00" Тогда
		НеделяПроизводства = Число(НеделяПроизводства);
		мГод = ГодПроизводства;
		Если Не ЗначениеЗаполнено(ГодПроизводства) Тогда 
			мГод = Год(ТекущаяДата());
		КонецЕсли;
		Если НеделяПроизводства > НеделяГода(КонецГода(Дата(мГод,1,1))) Тогда
			НеделяПроизводства = НеделяГода(КонецГода(Дата(мГод,1,1)));
		КонецЕсли;
	Иначе
		НеделяПроизводства = 1;
	КонецЕсли;
	
	НеделяПроизводстваСтрока = Формат(НеделяПроизводства, "ЧЦ=2; ЧВН=");
	Объект.ДатаПроизводстваШины = ДатаПоНомеруНедели(НеделяПроизводства, ГодПроизводства);
	ДатаПроизводстваШиныСтрока  = НеделяПроизводстваСтрока + Формат(Объект.ДатаПроизводстваШины, "ДФ=yy");
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СерийныйНомерПриИзменении(Элемент)
	
	// сброс флага, чтобы при записи был выполнен контроль дублей серийного номера
	НеобходимоЗаписать = Неопределено;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура НастроитьШаблон(Команда)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ОбъектНастройки", "Справочник_уатСерииНоменклатуры");
	ПараметрыФормы.Вставить("ТипАгрегата",     Объект.ТипАгрегата);
	
	ОткрытьФорму("ОбщаяФорма.уатНастройкаШаблона", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование(Команда)
	
	Объект.Наименование   = СформироватьНаименованиеСервер();
	НаименованиеПоШаблону = Объект.Наименование;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчетПробегИзносШин(Команда)
	
	ПараметрыОткрытия = ПолучитьПараметрыОткрытияОтчета("уатПробегИзносШин", "ОсновнаяСхемаКомпоновкиДанных",,Объект.Ссылка);
	ОткрытьФорму("Отчет.уатПробегИзносШин.Форма", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьПараметрыОткрытияОтчета(Отчет, Схема, ТС = Неопределено, мОбъект = Неопределено, КлючВарианта = Неопределено)
	
	Заказ        = Неопределено;
	Номенклатура = Неопределено;
	Если ТипЗнч(мОбъект) = Тип("Структура") Тогда
		Заказ        = мОбъект.Заказ;
		Номенклатура = мОбъект.Номенклатура;
	КонецЕсли;
	СхемаКомпоновкиДанных = Отчеты[Отчет].ПолучитьМакет(Схема);

	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКомпоновкиДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	НастройкиКомпоновки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	Для Каждого ТекЭлем Из НастройкиКомпоновки.Отбор.Элементы Цикл
		Если ЗначениеЗаполнено(ТС) И (Строка(ТекЭлем.ЛевоеЗначение) = "ТС" ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "ТСТекущее") Тогда
			ТекЭлем.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ТекЭлем.ПравоеЗначение = ТС;
			ТекЭлем.Использование = Истина;
		КонецЕсли;
		Если ЗначениеЗаполнено(ТС) И Строка(ТекЭлем.ЛевоеЗначение) = "ТСВыбыло" Тогда
			ТекЭлем.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			ТекЭлем.ПравоеЗначение = ЗначениеЗаполнено(ТС.ДатаВыбытия);
			ТекЭлем.Использование = Истина;
		КонецЕсли;
		Если ТипЗнч(мОбъект) <> Тип("Структура") Тогда
			Если ЗначениеЗаполнено(мОбъект) И (Строка(ТекЭлем.ЛевоеЗначение) = "Шина" 
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "СерияНоменклатуры"
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "Агрегат"
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "ВидТО"
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "ЗаявкаНаРемонт"
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "Номенклатура"
				ИЛИ Строка(ТекЭлем.ЛевоеЗначение) = "ВидОбслуживания") Тогда
				ТекЭлем.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ТекЭлем.ПравоеЗначение = мОбъект;
				ТекЭлем.Использование  = Истина;
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(Заказ) И (Строка(ТекЭлем.ЛевоеЗначение) = "ЗаявкаНаРемонт") Тогда
				ТекЭлем.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ТекЭлем.ПравоеЗначение = Заказ;
				ТекЭлем.Использование  = Истина;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Номенклатура) И (Строка(ТекЭлем.ЛевоеЗначение) = "Номенклатура") Тогда
				ТекЭлем.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
				ТекЭлем.ПравоеЗначение = Номенклатура;
				ТекЭлем.Использование  = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекЭлем Из НастройкиКомпоновки.ПараметрыДанных.Элементы Цикл
		Если ЗначениеЗаполнено(ТС) И Строка(ТекЭлем.Параметр) = "ОтображатьВыбывшиеТС" Тогда
			ТекЭлем.Значение     = ЗначениеЗаполнено(ТС.ДатаВыбытия);
			ТекЭлем.Использование = Истина;
		КонецЕсли;
		Если Строка(ТекЭлем.Параметр) = "ПериодОтчета" Тогда
			СтандартныйПериод = Новый СтандартныйПериод;
			СтандартныйПериод.ДатаНачала = Дата(1,1,1);
			СтандартныйПериод.ДатаОкончания = КонецДня(ТекущаяДата());
			ТекЭлем.Значение     = СтандартныйПериод;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиКомпоновки);

	сткПараметры = Новый Структура("СформироватьПриОткрытии, ПользовательскиеНастройки", Истина, КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
	
	Если ЗначениеЗаполнено(КлючВарианта) Тогда
		сткПараметры.Вставить("КлючВарианта", КлючВарианта);
	КонецЕсли;
	Возврат сткПараметры;
КонецФункции

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

&НаСервере
Функция ПолучитьПробегШины(Ссылка)
	Если Объект.Модель.ИзмерениеИзносаВЧасах Тогда
		Возврат "" + Справочники.уатСерииНоменклатуры.ПолучитьПробегШины(Ссылка) + НСтр("en=' h';ru=' ч'");
	Иначе
		Возврат "" + Справочники.уатСерииНоменклатуры.ПолучитьПробегШины(Ссылка) + НСтр("en=' km';ru=' км'");
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПроверкаУникальностиСерийногоНомера()
	Результат = Новый Массив;
	СпрОб = РеквизитФормыВЗначение("Объект");
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатСерииНоменклатуры.Наименование
	|ИЗ
	|	Справочник.уатСерииНоменклатуры КАК уатСерииНоменклатуры
	|ГДЕ
	|	уатСерииНоменклатуры.СерийныйНомер = &СерийныйНомер
	|	И уатСерииНоменклатуры.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("СерийныйНомер", СпрОб.СерийныйНомер);
	Запрос.УстановитьПараметр("Ссылка", СпрОб.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Результат.Добавить(Выборка.Наименование);
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ПриИзмененииТипаАгрегатаНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Модель) И Объект.Модель.ТипАгрегата <> Объект.ТипАгрегата Тогда
		Объект.Модель = ПредопределенноеЗначение("Справочник.уатМоделиАгрегатов.ПустаяСсылка");
	КонецЕсли;
	
	Если Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
		Объект.ГоденДо              = 0;
		Объект.НачалоЭксплуатации   = 0;
	Иначе
		Объект.ДатаПроизводстваШины = 0;
		Объект.СрокСлужбыШины       = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьИДоступностьЭлементовФормы()
	
	Если Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
		Элементы.ГруппаОбщийПробег.Видимость = Истина;
		Элементы.СтраницыЭксплуатация.ТекущаяСтраница = Элементы.ГруппаЭксплуатацияШин;
		
	Иначе
		Элементы.ГруппаОбщийПробег.Видимость = Ложь;
		Элементы.СтраницыЭксплуатация.ТекущаяСтраница = Элементы.ГруппаЭксплуатация;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииМоделиНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Модель) Тогда
		Объект.ТипАгрегата       = Объект.Модель.ТипАгрегата;
		Объект.ПараметрВыработки = Объект.Модель.ПараметрВыработки;
		Если Объект.ТипАгрегата = ПредопределенноеЗначение("Справочник.уатТипыАгрегатов.Шина") Тогда
			Объект.СрокСлужбыШины = Объект.Модель.СрокСлужбы;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораДатаПроизводстваШины(Дата, ДополнительныеПараметры) Экспорт
	
	Если НЕ Дата = Неопределено Тогда
		ГодПроизводства    = Формат(Дата, "ДФ=yy");
		НеделяПроизводства = НеделяГода(Дата);
		Объект.ДатаПроизводстваШины = Дата;
		НеделяПроизводства = Формат(НеделяПроизводства, "ЧЦ=2; ЧВН=");
		ДатаПроизводстваШиныСтрока = НеделяПроизводства + ГодПроизводства;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДатаПоНомеруНедели(НомерНедели, Год = "")
	
	Если НомерНедели = 1 Тогда
		Возврат Дата(?(Год = "", Год(ТекущаяДата()), Год),1,1)+(НомерНедели-НеделяГода(Дата(?(Год = "", Год(ТекущаяДата()), Год), 1, 1))) * 604800;
	Иначе
		Возврат НачалоНедели(Дата(?(Год = "", Год(ТекущаяДата()), Год),1,1)+(НомерНедели-НеделяГода(Дата(?(Год = "", Год(ТекущаяДата()), Год), 1, 1)))* 604800);
	КонецЕсли;
	
КонецФункции 

&НаСервере
Функция СформироватьНаименованиеСервер()
	
	СпрОб = РеквизитФормыВЗначение("Объект");
	Возврат уатНастройкиШаблонов.СформироватьНаименованиеПоШаблону("Справочник_уатСерииНоменклатуры", СпрОб);
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписьюШаблонНаименованияЗавершение(РезультатВопроса, НовоеНаименование) Экспорт
	
	ВопросСформироватьНаименование = Истина;
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Объект.Наименование   = СформироватьНаименованиеСервер();
		НаименованиеПоШаблону = Объект.Наименование;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
