
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();

	ЗаполнитьСписокВыбораОтветственного();
	
	ЗаполнитьСписокВыбораСостоянияОригиналаОтбор();
	ОтборСостояние = (НСтр("ru='<Состояние известно>'"));

	ОтображениеСписка = "ПоДокументам";

	НавигационнаяСсылка = "e1cib/app/Обработка.уатЖурналУчетаОригиналовПервичныхДокументов";

	ВосстановитьНастройки();

	УстановитьОтборыСписка();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
	ПараметрыРазмещения.Источники = Метаданные.ОпределяемыеТипы.ОбъектСУчетомОригиналовПервичныхДокументов.Тип;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументов.ПриСозданииНаСервере_ФормаСписка(ЭтотОбъект, Элементы.СписокДокументов, Элементы.СписокДокументовСумма);
	УчетОригиналовПервичныхДокументов.УстановитьУсловноеОформлениеВФормеСписка(ЭтотОбъект, Элементы.СписокДокументов);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ИспользоватьПодключаемоеОборудование = Истина;
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ПриПодключенииСканераШтрихкода(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ДобавлениеУдалениеСостоянияОригиналаПервичногоДокумента" Тогда
		 ЗаполнитьСписокВыбораСостоянияОригиналаОтбор();
	 КонецЕсли;	
	 
	// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов
	УчетОригиналовПервичныхДокументовКлиент.ОбработатьШтрихкод(Параметр,ИмяСобытия);
	УчетОригиналовПервичныхДокументовКлиент.ОбработчикОповещенияФормаСписка(ИмяСобытия, ЭтотОбъект, Элементы.СписокДокументов);
	// Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)

	УстановитьОтборыСписка()

КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторИзмененияПриИзменении(Элемент)

	УстановитьОтборыСписка()

КонецПроцедуры

&НаКлиенте
Процедура ОтображениеСпискаПриИзменении(Элемент)

	ОтображениеСпискаПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ОткрытьФорму("Справочник.СостоянияОригиналовПервичныхДокументов.Форма.ФормаВыбораСостояния",Новый Структура("СписокСостояний", ОтборСостоянияОригинала),Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УстановитьОтборПоСостояниюОригинала(ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОчистка(Элемент, СтандартнаяОбработка)

	ОтборСостоянияОригинала.Очистить();
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента");
 
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяНадписьОтборОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("УстановитьОтборПоВидуДокументаЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.уатЖурналУчетаОригиналовПервичныхДокументов.Форма.ФормаУстановкиОтбораВидовДокументов",
		Новый Структура("ОтборВидыДокументов",ОтборВидыДокументов), ЭтотОбъект,,,,Оповещение);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь; 
	Если Поле.Имя = "СостояниеОригиналаПервичногоДокумента" Или Поле.Имя = "СостояниеОригиналПолучен" Тогда
		УчетОригиналовПервичныхДокументовКлиент.СписокВыбор(Поле.Имя,ЭтотОбъект,Элементы.СписокДокументов,СтандартнаяОбработка);
	Иначе
		// Открываем документ
		ОткрытьДокумент();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьДокументКоманда(Команда)

	ОткрытьДокумент();

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервал(Команда)

	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Период;
	Диалог.Показать(Новый ОписаниеОповещения("УстановитьИнтервалЗавершение", ЭтотОбъект, Новый Структура("Диалог", Диалог)));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалЗавершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт

	Если ВыбранноеЗначение <> Неопределено Тогда
		ТекстЗаголовка = НСтр("ru='Журнал учета оригиналов первичных документов'")+ " ";
		Значения = Новый Структура("ДатаНачала, ДатаОкончания",Формат(ВыбранноеЗначение.ДатаНачала,НСтр("ru = 'ДФ=dd.MM.yy'; en = 'ДФ=dd.MM.yy'")),
			Формат(ВыбранноеЗначение.ДатаОкончания,НСтр("ru = 'ДФ=dd.MM.yy'; en = 'ДФ=dd.MM.yy'")));
			
		Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
			Заголовок = ТекстЗаголовка;
		ИначеЕсли Не ЗначениеЗаполнено(ВыбранноеЗначение.ДатаНачала) Тогда
			Заголовок = ТекстЗаголовка +СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='(по [ДатаОкончания])'"), Значения);
		ИначеЕсли Не ЗначениеЗаполнено(ВыбранноеЗначение.ДатаОкончания)Тогда
			Заголовок = ТекстЗаголовка +СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='(с [ДатаНачала])'"), Значения);
		ИначеЕсли ВыбранноеЗначение.Вариант = ВариантСтандартногоПериода.Сегодня Или ВыбранноеЗначение.Вариант = ВариантСтандартногоПериода.Вчера 
			Или  ВыбранноеЗначение.Вариант = ВариантСтандартногоПериода.Завтра Тогда
			Заголовок = ТекстЗаголовка +СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='([ДатаНачала])'"), Значения);
		Иначе
			Заголовок = ТекстЗаголовка +СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(НСтр("ru='(с [ДатаНачала] по [ДатаОкончания])'"), Значения);
		КонецЕсли;

		Период = ВыбранноеЗначение;

		УстановитьОтборПоПериоду();
	КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов

// Параметры:
//  Команда - КомандаФормы
//
&НаКлиенте
Процедура Подключаемый_УстановитьСостояниеОригинала(Команда)
	
	УчетОригиналовПервичныхДокументовКлиент.УстановитьСостояниеОригинала(Команда.Имя,ЭтотОбъект,Элементы.СписокДокументов);

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКомандыСостоянияОригинала()
	
	ОбновитьКомандыСостоянияОригинала()
   
КонецПроцедуры

&НаСервере
Процедура ОбновитьКомандыСостоянияОригинала()
	
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.СписокДокументовКоманднаяПанель;
	ПараметрыРазмещения.Источники = Метаданные.ОпределяемыеТипы.ОбъектСУчетомОригиналовПервичныхДокументов.Тип;
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
   
КонецПроцедуры

//Конец СтандартныеПодсистемы.УчетОригиналовПервичныхДокументов


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.СписокДокументов);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.СписокДокументов);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокДокументов);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект,
		"СписокДокументов.ДатаДокументаИБ",
		"СписокДокументовДатаДокументаИБ");
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект,
		"СписокДокументов.ДатаПервичногоДокумента",
		"СписокДокументовДатаПервичногоДокумента");

	Элемент = СписокДокументов.УсловноеОформление.Элементы.Добавить();

	ГруппаОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.Использование  = Истина;
	ГруппаОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбщееСостояние"); 
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбщееСостояние");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ПолеОтступа");

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	Элемент = СписокДокументов.УсловноеОформление.Элементы.Добавить();

	ЭлементОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбщееСостояние");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение =Истина;
	ЭлементОтбора.Использование = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветДополнительнойНавигации);

КонецПроцедуры

&НаСервере
Процедура ВосстановитьНастройки()

	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("Обработка.уатЖурналУчетаОригиналовПервичныхДокументов.Форма.Форма", "ОригиналыПервичныхДокументов");

	Если ТипЗнч(Настройки) = Тип("Структура") Тогда
		ОтборВидыДокументов = Настройки.ОтборВидыДокументов;
		ОтборОрганизация = Настройки.ОтборОрганизация;
		ОтборАвторИзменения = Настройки.ОтборАвторИзменения;
		ОтборСостояние = Настройки.ОтборСостояние;
		КоличествоДокументов = Настройки.КоличествоДокументов;
		ПрошлыйОтборСостоянияОригинала = Настройки.ОтборСостоянияОригинала; 
		ОтображениеСписка = Настройки.ОтображениеСписка;

		// Восстанавливаем список отбора по состояниям
		Если ЗначениеЗаполнено(ПрошлыйОтборСостоянияОригинала) Тогда
			Для Каждого Состояние Из ПрошлыйОтборСостоянияОригинала Цикл
				ОтборСостоянияОригинала.Добавить(Состояние.Значение);
			КонецЦикла;
		КонецЕсли;
	
	Иначе// Если нет сохраненных настроек заполняем список для отбора по виду документов
		ЗаполнитьПервоначальныйСписокВыбораВидовДокумента();
		ОтборСостояние = НСтр("ru='<Состояние известно>'");		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()

	ИменаСохраняемыхРеквизитов =
		"ОтборВидыДокументов,
		|ОтборОрганизация,
		|ОтборАвторИзменения,
		|ОтборСостояние,
		|КоличествоДокументов,
		|ОтборСостоянияОригинала,
		|ОтображениеСписка";

	Настройки = Новый Структура(ИменаСохраняемыхРеквизитов);
	ЗаполнитьЗначенияСвойств(Настройки, ЭтаФорма);

	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("Обработка.уатЖурналУчетаОригиналовПервичныхДокументов.Форма.Форма", "ОригиналыПервичныхДокументов",Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДокумент()

	Если Элементы.СписокДокументов.ВыделенныеСтроки = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выделено ни одного документа.'"));
		Возврат;
	КонецЕсли;
		
	Для Каждого СтрокаСписка Из Элементы.СписокДокументов.ВыделенныеСтроки Цикл
		Документ = Элементы.СписокДокументов.ДанныеСтроки(СтрокаСписка);
		ПоказатьЗначение(,Документ.Ссылка);
	КонецЦикла;

КонецПроцедуры

#Область Отборы

&НаСервере
Процедура ЗаполнитьСписокВыбораОтветственного()

	УстановитьПривилегированныйРежим(Истина);

	МассивПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей();

	Элементы.ОтборАвторИзменения.СписокВыбора.Очистить();
	Элементы.ОтборАвторИзменения.СписокВыбора.Добавить(Пользователи.ТекущийПользователь(),НСтр("ru='<Мои записи>'"));

	Для Каждого Пользователь Из МассивПользователей Цикл

		Если Пользователь.Роли.Содержит(Метаданные.Роли.ИзменениеСостоянийОригиналовПервичныхДокументов) 
			И Не Пользователи.ТекущийПользователь() = Пользователи.НайтиПоИмени(Пользователь.Имя) Тогда
			НайденныйПользователь =Пользователи.НайтиПоИмени(Пользователь.Имя);
			Элементы.ОтборАвторИзменения.СписокВыбора.Добавить(НайденныйПользователь);
		КонецЕсли;

	КонецЦикла;

	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораСостоянияОригиналаОтбор()

	СостоянияОригинала = УчетОригиналовПервичныхДокументов.ВсеСостояния();
	
	Элементы.ОтборСостояние.СписокВыбора.Очистить();
	Для Каждого Состояние Из СостоянияОригинала Цикл
		Элементы.ОтборСостояние.СписокВыбора.Добавить(Состояние);
	КонецЦикла;
	Элементы.ОтборСостояние.СписокВыбора.Добавить("Состояниеизвестно",НСтр("ru='<Состояние известно>'"));
	Элементы.ОтборСостояние.СписокВыбора.Добавить("Состояниенеизвестно",НСтр("ru='<Состояние неизвестно>'"));
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПервоначальныйСписокВыбораВидовДокумента() 

	ТаблицаВидыДокументов.Очистить();

	ДоступныеТипы = Метаданные.ОпределяемыеТипы.ОбъектСУчетомОригиналовПервичныхДокументов.Тип.Типы();
	ИменаДокументов = Новый Массив;
	Для Каждого Тип Из ДоступныеТипы Цикл
		ТипДокумента = Метаданные.НайтиПоТипу(Тип);
		ИменаДокументов.Добавить(ТипДокумента.ПолноеИмя());
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ИдентификаторыОбъектовМетаданных.ПолноеИмя КАК ПолноеИмя,
	               |	ИдентификаторыОбъектовМетаданных.Синоним КАК Синоним,
	               |	ИдентификаторыОбъектовМетаданных.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
	               |ГДЕ
	               |	ИдентификаторыОбъектовМетаданных.ПолноеИмя В(&ИменаДокументов)";
	Запрос.УстановитьПараметр("ИменаДокументов",ИменаДокументов);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Отбор = Новый Структура("Представление", Выборка.Синоним);
		НайденныеСтроки = ТаблицаВидыДокументов.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество()= 0 Тогда
			НоваяСтрока = ТаблицаВидыДокументов.Добавить();
			НоваяСтрока.ВидДокумента = Выборка.Ссылка;
			НоваяСтрока.Представление = Выборка.Синоним;
			НоваяСтрока.Отбор = Истина;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписка()

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"Организация",ОтборОрганизация,
		ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(ОтборОрганизация));

	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"АвторИзменения",ОтборАвторИзменения,
		ВидСравненияКомпоновкиДанных.Равно,,ЗначениеЗаполнено(ОтборАвторИзменения));

	УстановитьОтборПоВидуДокумента(ОтборВидыДокументов);
	
	ОтображениеСпискаПриИзмененииНаСервере();

	УстановитьОтборПоСостояниюОригинала();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоВидуДокументаЗавершение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	УстановитьОтборПоВидуДокумента(Результат);
	
КонецПроцедуры	
	
&НаСервере
Процедура УстановитьОтборПоВидуДокумента(Результат)

	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокДокументов,"ТипСсылки");
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда 
			Массив = Новый Массив;
			КоличествоДокументов = Результат.КоличествоДокументов;
			Для Каждого Отбор Из Результат.ОтборВидыДокументов Цикл
				Массив.Добавить(Отбор.Значение);
			КонецЦикла;
		Иначе			
			Массив = Новый Массив;
			Для Каждого Отбор Из Результат Цикл
				Массив.Добавить(Отбор.Значение);
			КонецЦикла;
		КонецЕсли;
		
		ОтборВидыДокументов.ЗагрузитьЗначения(Массив);
				
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"ТипСсылки",ОтборВидыДокументов,
			ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

		Если ОтборВидыДокументов.Количество() = КоличествоДокументов Или ОтборВидыДокументов.Количество()= 0 Тогда
			Элементы.ИнформационнаяНадписьОтбор.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Показаны все документы журнала <a href=""НастроитьОтбор"">Настроить</a>'"));
		Иначе	
			ТекстНадписи = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(НСтр("ru = ';Показан %1 документ журнала;;
			|Показано %1 документа журнала;Показано %1 документов журнала;'"),ОтборВидыДокументов.Количество());
			Элементы.ИнформационнаяНадписьОтбор.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(ТекстНадписи + " " +НСтр("ru = '<a href=""НастроитьОтбор"">Настроить</a>'"));	
		КонецЕсли;

	Иначе
		Если Не ТаблицаВидыДокументов.Количество() = 0 Тогда
			Массив = Новый Массив;
			Для Каждого Отбор Из ТаблицаВидыДокументов Цикл
				Массив.Добавить(Отбор.ВидДокумента);
			КонецЦикла;
		ОтборВидыДокументов.ЗагрузитьЗначения(Массив);		
		
		Элементы.ИнформационнаяНадписьОтбор.Заголовок = СтроковыеФункции.ФорматированнаяСтрока(НСтр("ru = 'Показаны все документы журнала <a href=""НастроитьОтбор"">Настроить</a>'"));

		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"ТипСсылки",ОтборВидыДокументов,
			ВидСравненияКомпоновкиДанных.ВСписке,,Истина);

		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСостояниюОригинала(ВыбранноеЗначение = Неопределено) 	

	ОтборСостояние = "";

	Если ВыбранноеЗначение=Неопределено И ОтборСостоянияОригинала.Количество()>1 Тогда 
		Для Каждого Состояние Из ОтборСостоянияОригинала Цикл
			Если Состояние.Значение = "Состояниенеизвестно" Тогда
				Неизвестные = Истина;
			КонецЕсли;
			ОтборСостояние = ОтборСостояние + ?(ЗначениеЗаполнено(ОтборСостояние), ", ", "")+ Состояние.Значение;
		КонецЦикла;
			
	ИначеЕсли ВыбранноеЗначение=Неопределено И ОтборСостоянияОригинала.Количество()=1 Тогда
		ОтборСостояние = ОтборСостоянияОригинала[0].Значение;
		Если ОтборСостоянияОригинала[0].Значение = "Состояниенеизвестно" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента",,
				ВидСравненияКомпоновкиДанных.НеЗаполнено,,ЗначениеЗаполнено(ОтборСостояние));
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СписокЗначений") Тогда
		ОтборСостоянияОригинала.Очистить();
		ПроверкаНаВсеПустыеПометки = 0;
		Для Каждого Состояние Из ВыбранноеЗначение Цикл
			Если Состояние.Пометка Тогда
				Если Состояние.Значение = "Состояниенеизвестно" Тогда
					Неизвестные = Истина;
					ОтборСостоянияОригинала.Добавить(Состояние.Значение);
					ОтборСостояние = ОтборСостояние + ?(ЗначениеЗаполнено(ОтборСостояние), ", ", "")+ Состояние.Представление;
				Иначе
					ОтборСостоянияОригинала.Добавить(Состояние.Значение);
					ОтборСостояние = ОтборСостояние + ?(ЗначениеЗаполнено(ОтборСостояние), ", ", "")+ Состояние.Значение;
				КонецЕсли;
			Иначе
				ПроверкаНаВсеПустыеПометки = ПроверкаНаВсеПустыеПометки + 1; 
			КонецЕсли;
			
		КонецЦикла;
		Если ПроверкаНаВсеПустыеПометки = ВыбранноеЗначение.Количество() Тогда
			Неизвестные = Истина;
			Для Каждого Состояние Из ВыбранноеЗначение Цикл
				ОтборСостоянияОригинала.Добавить(Состояние.Значение);
			КонецЦикла;
		КонецЕсли;
	Иначе 
		ОтборСостоянияОригинала.Очистить();
		Если Не ВыбранноеЗначение=Неопределено Тогда
			Если ВыбранноеЗначение = "Состояниенеизвестно" Тогда
				ОтборСостояние = НСтр("ru='<Состояние неизвестно>'");
			ИначеЕсли ВыбранноеЗначение = "Состояниеизвестно" Тогда
				ОтборСостояние = НСтр("ru='<Состояние известно>'");
			Иначе
				ОтборСостояние = ВыбранноеЗначение;
			КонецЕсли;
		КонецЕсли;
		
		ОтборСостоянияОригинала.Добавить(ВыбранноеЗначение);
		Если ВыбранноеЗначение = "Состояниенеизвестно" Или ОтборСостояние = "Состояниенеизвестно" Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента",,
				ВидСравненияКомпоновкиДанных.НеЗаполнено,,ЗначениеЗаполнено(ОтборСостояние));
			Возврат;
		ИначеЕсли ВыбранноеЗначение = "Состояниеизвестно" Или ОтборСостояние = "Состояниеизвестно" Тогда
				ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента",,
			ВидСравненияКомпоновкиДанных.Заполнено,,ЗначениеЗаполнено(ОтборСостояние));
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если Неизвестные = Истина Тогда
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента");
		
		ГруппаОтбора = СписокДокументов.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.Использование  = Истина;
		ГруппаОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеОригиналаПервичногоДокумента");; 
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СостояниеОригиналаПервичногоДокумента");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		ЭлементОтбора.ПравоеЗначение = ОтборСостоянияОригинала;
		
	ИначеЕсли ЗначениеЗаполнено(ОтборСостояние) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокДокументов,"СостояниеОригиналаПервичногоДокумента",ОтборСостоянияОригинала,
			ВидСравненияКомпоновкиДанных.ВСписке,,ЗначениеЗаполнено(ОтборСостояние));	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтображениеСпискаПриИзмененииНаСервере()

	// Обнуляем отбор по общему состоянию
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(СписокДокументов,"ОбщееСостояние");

	Если ОтображениеСписка = "ПоДокументам" Тогда
		
		ГруппаОтбора = СписокДокументов.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаОтбора.Использование  = Истина;
		ГруппаОтбора.ТипГруппы  = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		
		// Задаем новый отбор для отображения списка "по документам"
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбщееСостояние");; 
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ОбщееСостояние");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Истина;

		Элементы.ПолеОтступа.Видимость = Ложь;
		Элементы.ПервичныйДокументПредставление.Видимость = Ложь;

	ИначеЕсли ОтображениеСписка = "ПоПечатнымФормам" Тогда
		Элементы.ПолеОтступа.Видимость = Истина;
		Элементы.ПервичныйДокументПредставление.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериоду()

	СписокДокументов.Параметры.УстановитьЗначениеПараметра("НачалоПериода", Период.ДатаНачала);
	СписокДокументов.Параметры.УстановитьЗначениеПараметра("КонецПериода",  Период.ДатаОкончания);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
