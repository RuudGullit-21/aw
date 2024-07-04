
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
	ВнешняяСистема = ПолучитьЗначениеРеквизита(Объект.УчетнаяЗаписьПЦ, "ВнешняяСистема");
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ИспользоватьСтандартнуюОбработкуЗагрузкиДанныхПЦ = Истина;
		Контрагент_Склад = ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
		УстановитьТипПоляКонтрагентСклад();
	КонецЕсли;
	
	Если Объект.ВидЗагрузкиДанныхОтПЦ = Перечисления.уатВидыЗагрузкиДанныхОтПЦ.ЗагрузкаИзФайла Тогда
		Элементы.ГруппаВидЗагрузкиДанныхОтПЦ.Видимость = Константы.уатИспользоватьАвтоматическуюЗагрузкуОтчетовПЦ.Получить();
	КонецЕсли;
	
	Если уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		Элементы.ГруппаВидЗагрузкиДанныхОтПЦ.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьОтборЦен();
	ПрочитатьДанныеТегов();
	ОбновитьЭлементыТеговГруппыКарт();
	
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
	
	ВидИспользуемойОбработки = ?(Объект.ИспользоватьСтандартнуюОбработкуЗагрузкиДанныхПЦ, 0, 1);
	УстановитьВидимостьЗагрузкаДанныхПЦ();
	
	ОбновитьНадписьКонтрагентСклад();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПрочитатьДанныеТегов();
	УстановитьОтборЦен();
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
	
	ТекстОшибки = "";
	
	Если ЭтоАдресВременногоХранилища(ФайлОбработкиАдрес) Тогда
		ТекущийОбъект.ФайлВнешнейОбработки = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ФайлОбработкиАдрес), Новый СжатиеДанных(9));
	ИначеЕсли ФлагУдаленияФайла Тогда
		ТекущийОбъект.ФайлВнешнейОбработки = Новый ХранилищеЗначения(Неопределено);
	КонецЕсли;
	
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
	
	ПрочитатьДанныеТегов();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭтоАЗССкладПриИзменении(Элемент)
	
	ВозможностьИзменения = ПолучитьВозможностьИзмененияАЗССклад(Объект.Ссылка, Объект.ЭтоАЗССклад);
	
	ДопПараметры = Новый Структура("СтароеЗначение", ВозможностьИзменения.СтароеЗначение);
	
	Если ВозможностьИзменения.ИзменениеВозможно Тогда 
		ЭтоАЗССкладПриИзмененииПродолжение(КодВозвратаДиалога.Да, ДопПараметры);
	Иначе 
		ОповещениеОИзмененииЭтоАЗССклад = Новый ОписаниеОповещения("ЭтоАЗССкладПриИзмененииПродолжение", ЭтотОбъект, ДопПараметры);
		ТекстНСТР = НСтр("en='Gas stations involved in movement of fuels. Change is not recommended. Continue?';ru='АЗС участвует в движении ГСМ. Изменение не рекомендуется. Продолжить?'");
		ПоказатьВопрос(ОповещениеОИзмененииЭтоАЗССклад, ТекстНСТР, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Контрагент_СкладПриИзменении(Элемент)
	УстановитьСписокАЗСцены();
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеГСМГСМНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ДополнительныеПараметры	 = Новый Структура("ЗначениеГСМДоИзменения, УчитыватьТЖ", Элементы.СоответствиеГСМ.ТекущиеДанные.ГСМ, Истина);
	ОписаниеОповещенияЗакр	 = Новый ОписаниеОповещения("ОписаниеОповещенияВыбораГСМ", ЭтотОбъект, ДополнительныеПараметры);
	
	уатЗащищенныеФункцииКлиент.ВыбратьГСМ(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"), ДополнительныеПараметры, ОписаниеОповещенияЗакр);
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеГСМГСМОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекГСМ = Элементы.СоответствиеГСМ.ТекущиеДанные.ГСМ;
	Если ЗначениеЗаполнено(ТекГСМ) Тогда
		ОткрытьФорму("РегистрСведений.уатНоменклатураГСМ.ФормаЗаписи", Новый Структура("Ключ", 
			ПолучитьКлючЗаписиГСМ(ТекГСМ)), Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеГСМГСМАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	мсвГруппДляОтбора = Новый Массив;
	мсвГруппДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
	ДанныеВыбора = уатГСМ.ПолучитьСписокАвтоподбораПоляГСМ(Текст, мсвГруппДляОтбора, Новый Структура("УчитыватьТЖ", Истина));
КонецПроцедуры

&НаКлиенте
Процедура СоответствиеГСМГСМОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПараметрыПолученияДанных.СтрокаПоиска = "";
КонецПроцедуры

&НаКлиенте
Процедура ЦеныКонтрагентовПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	уатОбщегоНазначенияКлиент.ПроверитьЗаписьНовогоОбъектаВФорме(ЭтотОбъект, Объект.Ссылка,,, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	Если Копирование Тогда 
		СтруктураЗаполнения = Новый Структура("Контрагент, Номенклатура, Цена, Валюта");
		СтруктураЗаполнения.Контрагент   = Элемент.ТекущиеДанные.Контрагент;
		СтруктураЗаполнения.Номенклатура = Элемент.ТекущиеДанные.Номенклатура;
		СтруктураЗаполнения.Цена = Элемент.ТекущиеДанные.Цена;
		СтруктураЗаполнения.Валюта = Элемент.ТекущиеДанные.Валюта;
		ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения", СтруктураЗаполнения);
	Иначе
		СтруктураЗаполнения = Новый Структура("Контрагент");
		СтруктураЗаполнения.Контрагент = Объект.Ссылка;
		ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения", СтруктураЗаполнения);
	КонецЕсли;
		
	ОткрытьФорму("РегистрСведений.уатЦеныНоменклатурыКонтрагентов.ФормаЗаписи",
		ПараметрыОткрытия, ЭтотОбъект,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВидЗагрузкиДанныхОтПЦПриИзменении(Элемент)
	Объект.УчетнаяЗаписьПЦ = ПредопределенноеЗначение("Справочник.уатУчетныеЗаписиПЦ.ПустаяСсылка");
	УстановитьВидимостьЗагрузкаДанныхПЦ();
КонецПроцедуры

&НаКлиенте
Процедура УчетнаяЗаписьПЦПриИзменении(Элемент)
	ВнешняяСистема = ПолучитьЗначениеРеквизита(Объект.УчетнаяЗаписьПЦ, "ВнешняяСистема");
	УстановитьВидимостьЗагрузкаДанныхПЦ();
КонецПроцедуры

&НаКлиенте
Процедура ПрофильОбменаСПЦПриИзменении(Элемент)
	УстановитьВидимостьЗагрузкаДанныхПЦ();
КонецПроцедуры

&НаКлиенте
Процедура ВидИспользуемойОбработкиПриИзменении(Элемент)
	Объект.ИспользоватьСтандартнуюОбработкуЗагрузкиДанныхПЦ	 = ВидИспользуемойОбработки = 0;
	УстановитьВидимостьЗагрузкаДанныхПЦ();
	Модифицированность = Истина;
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
Процедура ИзменитьФайлВнешнейОбработки(Команда)
	Отказ = Ложь;
	уатОбщегоНазначенияКлиент.ПроверитьЗаписьНовогоОбъектаВФорме(ЭтотОбъект, Объект.Ссылка,,, Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ФлагУдаленияФайла = Ложь;
	
	ПараметрыДиалога = Новый Структура("Режим, Фильтр, ИндексФильтра, Заголовок");
	ПараметрыДиалога.Режим  = РежимДиалогаВыбораФайла.Открытие;
	ПараметрыДиалога.Фильтр = НСтр("en='External processing';ru='Внешняя обработка'") + "(*.epf)|*.epf";
	ПараметрыДиалога.ИндексФильтра = 0;
	ПараметрыДиалога.Заголовок = НСтр("ru='Выберите файл для сохранения внешней обработки'");
	
	ОбработчикВыбораФайлаОбработки = Новый ОписаниеОповещения("ИзменитьФайлПослеВыбораФайлаОбработки", ЭтотОбъект);
	//СтандартныеПодсистемыКлиент.ПоказатьПомещениеФайла(ОбработчикВыбораФайлаОбработки, УникальныйИдентификатор, "", ПараметрыДиалога);
	
	ПараметрыЗагрузкиФайла = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузкиФайла.ИдентификаторФормы = УникальныйИдентификатор;
	ЗаполнитьЗначенияСвойств(ПараметрыЗагрузкиФайла.Диалог, ПараметрыДиалога);
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикВыбораФайлаОбработки, ПараметрыЗагрузкиФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФайлПослеВыбораФайлаОбработки(Результат, ДопПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		ФайлОбработкиАдрес = Результат.Хранение;
		УстановитьВидимостьЗагрузкаДанныхПЦ();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлВнешнейОбработка(Команда)
	ФайлОбработкиАдрес = "";
	ФлагУдаленияФайла = Истина;
	УстановитьВидимостьЗагрузкаДанныхПЦ();
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьФайлВнешнейОбработки(Команда)
	
	Обработчик        = Новый ОписаниеОповещения("ПоказатьДиалогВыбораФайлаВнешнейОбработки", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Обработчик);

КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияОткрытие(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", "Инструкция по загрузке отчетов поставщиков процессинговых центров");
	ПараметрыФормы.Вставить("ИмяМакета", "Справочник.уатАЗС.ИнструкцияПоЗагрузкеОтчетовПЦ");
	ОткрытьФорму("ОбщаяФорма.уатДополнительноеОписание",ПараметрыФормы);	

КонецПроцедуры

&НаКлиенте
Процедура ПримерФайлаОтчетаОткрытие()
	
	#Если НЕ ВебКлиент Тогда
	АдресВременногоХранилища = ПолучитьПримерФайлаНаСервере();
	Если НЕ АдресВременногоХранилища = Неопределено Тогда
		ОбразецВрем = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
		ВремФайл = ПолучитьИмяВременногоФайла(".xlsx");
		Попытка
			ОбразецВрем.Записать(ВремФайл);
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Не удалось выгрузить образец во временный файл на диске:%1'"), Символы.ПС + ОписаниеОшибки());
			Сообщение.Сообщить();
			Возврат;
		КонецПопытки;
		ЗапуститьПриложение(ВремФайл);
	КонецЕсли;
	#Иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не поддерживается в веб-клиенте!";
		Сообщение.Сообщить();
	#КонецЕсли
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПримерФайлаНаСервере()
		
	ДвоичныеДанныеФайла = Справочники.уатАЗС.ПолучитьМакет("ОбразецФайлаДанныхПЦ");
	Возврат ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла, Новый УникальныйИдентификатор);
	          	
КонецФункции

&НаКлиенте
Процедура ЗагрузкаТоваров(Команда)
	
	ВнешняяСистема = ЗначениеРеквизитаОбъекта(Объект.УчетнаяЗаписьПЦ, "ВнешняяСистема");
	Если ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.Газпромнефть") Тогда
		ЗагрузкаТоваровГазпром();
	ИначеЕсли ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ЛукойлЛИКАРД") Тогда
		ЗагрузкаТоваровЛукойл();
	ИначеЕсли ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.Роснефть") Тогда
		ЗагрузкаТоваровРоснефть();
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

&НаКлиенте
Процедура ЗагрузкаТоваровГазпромФрагмент()

	ТекстОшибки = "";
	
	СтруктураПараметровУчетнойЗаписи = уатЗагрузкаПЦ.ПолучитьСтруктуруПараметровДляРаботыСПЦ(Объект.УчетнаяЗаписьПЦ);
	МассивГСМ = уатЗагрузкаПЦ.Газпромнефть_ПолучитьМассивГСМ(СтруктураПараметровУчетнойЗаписи, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Для Каждого ТекГСМ Из МассивГСМ Цикл
		НоваяСтрокаСоответствиеГСМ = Объект.СоответствиеГСМ.Добавить();
		НоваяСтрокаСоответствиеГСМ.ГСМизФайла = ТекГСМ.Наименование;
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровЛукойлФрагмент()

	ТекстОшибки	  = "";
	
	СтруктураПараметровУчетнойЗаписи = уатЗагрузкаПЦ.ПолучитьСтруктуруПараметровДляРаботыСПЦ(Объект.УчетнаяЗаписьПЦ);
	МассивТоваров = уатЗагрузкаПЦ.ЛИКАРД_ПолучитьСписокТоваров(СтруктураПараметровУчетнойЗаписи, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;

	Если ТипЗнч(МассивТоваров) = Тип("Массив") Тогда
		Для Каждого ТекГСМ Из МассивТоваров Цикл
			НоваяСтрокаСоответствиеГСМ = Объект.СоответствиеГСМ.Добавить();
			НоваяСтрокаСоответствиеГСМ.ГСМизФайла    = ТекГСМ;
		КонецЦикла;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровРоснефтьФрагмент()

	ТекстОшибки	  = "";
	
	СтруктураПараметровУчетнойЗаписи = уатЗагрузкаПЦ.ПолучитьСтруктуруПараметровДляРаботыСПЦ(Объект.УчетнаяЗаписьПЦ);
	МассивТоваров = уатЗагрузкаПЦ.Роснефть_ПолучитьМассивГСМ(СтруктураПараметровУчетнойЗаписи, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;

	Если ТипЗнч(МассивТоваров) = Тип("Массив") Тогда
		Для Каждого ТекГСМ Из МассивТоваров Цикл
			НоваяСтрокаСоответствиеГСМ = Объект.СоответствиеГСМ.Добавить();
			НоваяСтрокаСоответствиеГСМ.ГСМизФайла    = ТекГСМ.Наименование;
		КонецЦикла;
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписьКонтрагентСклад()
	Если Объект.ЭтоАЗССклад Тогда
		Элементы.Контрагент_Склад.Заголовок = НСтр("en='Warehouse';ru='Склад'");
	Иначе
		Элементы.Контрагент_Склад.Заголовок = НСтр("en='Counterpartу';ru='Контрагент'");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборЦен()
	Если Объект.ЭтоАЗССклад Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЦеныКонтрагентов.Отбор, "Контрагент", Объект.Ссылка, 
			ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		СписокОтбор = Новый СписокЗначений;
		СписокОтбор.Добавить(Объект.Ссылка);
		СписокОтбор.Добавить(Объект.Контрагент_Склад);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ЦеныКонтрагентов.Отбор, "Контрагент", СписокОтбор, 
			ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьТипПоляКонтрагентСклад()
	Если Объект.ЭтоАЗССклад Тогда
		Элементы.Контрагент_Склад.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Склады");
	Иначе
		Элементы.Контрагент_Склад.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
	КонецЕсли;	
	Объект.Контрагент_Склад = Элементы.Контрагент_Склад.ОграничениеТипа.ПривестиЗначение(Объект.Контрагент_Склад);
КонецПроцедуры

&НаСервере
Функция ЕстьОбработкаЗагрузкиГСМвАЗС(АЗС)
	Если НЕ ЗначениеЗаполнено(АЗС) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ФлагУдаленияФайла = Истина Тогда 
		Результат = Ложь;
	Иначе
		Если ЗначениеЗаполнено(АЗС.ФайлВнешнейОбработки.Получить()) 
			ИЛИ ЗначениеЗаполнено(ФайлОбработкиАдрес) Тогда
			Результат = Истина;
		Иначе
			Результат = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции // ПроверитьОбработкуЗагрузки

&НаСервереБезКонтекста
Функция ПолучитьКлючЗаписиГСМ(ТекГСМ)
	КлючЗаписиГСМ = РегистрыСведений.уатНоменклатураГСМ.СоздатьКлючЗаписи(Новый Структура("Номенклатура", ТекГСМ));
	Возврат КлючЗаписиГСМ;
КонецФункции

&НаКлиенте
Процедура УстановитьСписокАЗСцены()
	СписокОтбор = Новый СписокЗначений;
	СписокОтбор.Добавить(Объект.Ссылка);
	СписокОтбор.Добавить(Объект.Контрагент_Склад);
		
	Элементы.ЦеныКонтрагентовКонтрагент.СписокВыбора.Очистить();
	Если НЕ Объект.Ссылка.Пустая() Тогда
		Элементы.ЦеныКонтрагентовКонтрагент.СписокВыбора.Добавить(Объект.Ссылка);
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.Контрагент_Склад) Тогда
		Элементы.ЦеныКонтрагентовКонтрагент.СписокВыбора.Добавить(Объект.Контрагент_Склад);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьЗагрузкаДанныхПЦ()
	
	Элементы.УчетнаяЗаписьПЦ.ОтметкаНезаполненного  = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка")
		И НЕ ЗначениеЗаполнено(Объект.УчетнаяЗаписьПЦ);
	Элементы.ПрофильОбменаСПЦ.ОтметкаНезаполненного = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка")
		И НЕ ЗначениеЗаполнено(Объект.ПрофильОбменаСПЦ);

	Элементы.ГруппаУчетнаяЗаписьПЦ.Видимость				 = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка");
	Элементы.ВидИспользуемойОбработки.Видимость				 = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.ЗагрузкаИзФайла");
	Элементы.СоответствиеГСМЗагрузкаТоваров.Видимость		 = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка")
		И ЗначениеЗаполнено(Объект.УчетнаяЗаписьПЦ) И ВнешняяСистема <> ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ППР");
	Элементы.ГруппаИзменитьФайлКоманды.Видимость			 = ВидИспользуемойОбработки = 1 И Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.ЗагрузкаИзФайла");
	Если Элементы.ГруппаИзменитьФайлКоманды.Видимость Тогда
		Элементы.УдалитьФайлВнешнейОбработка.Видимость = ЕстьОбработкаЗагрузкиГСМвАЗС(Объект.Ссылка);
	КонецЕсли;
	
	Элементы.ГруппаОтдел.Видимость = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка")
		И ЗначениеЗаполнено(Объект.УчетнаяЗаписьПЦ)
		И ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.ППР")
		И ПолучитьЗначениеРеквизита(Объект.УчетнаяЗаписьПЦ, "РазбиватьНаОтделы");
		
	Элементы.ТегиГруппыКарт.Видимость = Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.АвтоматическаяЗагрузка")
		И ЗначениеЗаполнено(Объект.УчетнаяЗаписьПЦ)
		И ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.Газпромнефть");
	
	Элементы.ГруппаПримерИнструкция.Видимость = НЕ Объект.ИспользоватьСтандартнуюОбработкуЗагрузкиДанныхПЦ И 
		Объект.ВидЗагрузкиДанныхОтПЦ = ПредопределенноеЗначение("Перечисление.уатВидыЗагрузкиДанныхОтПЦ.ЗагрузкаИзФайла");;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизита(Объект, ИмяРеквизита)
	Возврат уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(Объект, ИмяРеквизита);
КонецФункции

&НаКлиенте
Процедура СохранитьШаблонФайлаПослеВыбораФайла(Результат, ДопПараметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ФайлВыгрузки = Результат[0];
	Если ПустаяСтрока(ФайлВыгрузки) Тогда
		ТекстОшибки = НСтр("en='It is necessary to specify the upload file.';ru='Необходимо указать файл выгрузки.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Возврат;
	КонецЕсли;
		
	ДополнительныеПараметры = Новый Структура();
	Оповещение = Новый ОписаниеОповещения("СохранитьШаблонФайлаВВыбранныйФайл", ЭтотОбъект, ДополнительныеПараметры);
	
	ДвоичныеДанные = ПолучитьДвоичныеДанныеОбработки();
	ДвоичныеДанные.НачатьЗапись(Оповещение, ФайлВыгрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьШаблонФайлаВВыбранныйФайл(ДопПараметры) Экспорт
	
	ДопОбработкаНеТребуется = Истина;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДвоичныеДанныеОбработки()
	
	Если ЕстьОбработкаЗагрузкиГСМвАЗС(Объект.Ссылка) И НЕ ФлагУдаленияФайла Тогда
		Если ЭтоАдресВременногоХранилища(ФайлОбработкиАдрес) Тогда
			ФайлВнешнейОбработки = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(ФайлОбработкиАдрес), Новый СжатиеДанных(9));
		Иначе
			ФайлВнешнейОбработки = Объект.Ссылка.ФайлВнешнейОбработки;
		КонецЕсли;
		ДвоичныеДанные = ФайлВнешнейОбработки.Получить();
	Иначе
		ДвоичныеДанные = ПолучитьОбщийМакет("уатСтандартнаяОбработкаЗагрузкиДанныхПЦ");
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьВозможностьИзмененияАЗССклад(Знач СправочникСсылка, Знач НовоеЗначение)
	
	Результат = Новый Структура("ИзменениеВозможно, НовоеЗначение, СтароеЗначение");
	
	мЗапрос = Новый Запрос();
	мЗапрос.УстановитьПараметр("АЗС", СправочникСсылка);
	
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатПластиковыеКарты.Ссылка
	|ИЗ
	|	Справочник.уатПластиковыеКарты КАК уатПластиковыеКарты
	|ГДЕ
	|	уатПластиковыеКарты.КемВыдана = &АЗС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатЗаправкаГСМ.Ссылка
	|ИЗ
	|	Документ.уатЗаправкаГСМ КАК уатЗаправкаГСМ
	|ГДЕ
	|	уатЗаправкаГСМ.АЗС = &АЗС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатИнвентаризацияГСМвТС.Ссылка
	|ИЗ
	|	Документ.уатИнвентаризацияГСМвТС КАК уатИнвентаризацияГСМвТС
	|ГДЕ
	|	уатИнвентаризацияГСМвТС.АЗС = &АЗС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатОтчетПоставщикаПЦ.Ссылка
	|ИЗ
	|	Документ.уатОтчетПоставщикаПЦ КАК уатОтчетПоставщикаПЦ
	|ГДЕ
	|	уатОтчетПоставщикаПЦ.АЗС = &АЗС
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	уатСливГСМ.Ссылка
	|ИЗ
	|	Документ.уатСливГСМ КАК уатСливГСМ
	|ГДЕ
	|	уатСливГСМ.АЗС = &АЗС";
	
	Если СправочникСсылка.Пустая() Или СправочникСсылка.ЭтоАЗССклад = НовоеЗначение Или мЗапрос.Выполнить().Пустой() Тогда 
		Результат.ИзменениеВозможно = Истина;
		Результат.НовоеЗначение     = НовоеЗначение;
		Результат.СтароеЗначение    = СправочникСсылка.ЭтоАЗССклад;
		
	Иначе 
		Результат.ИзменениеВозможно = Ложь;
		Результат.НовоеЗначение     = НовоеЗначение;
		Результат.СтароеЗначение    = СправочникСсылка.ЭтоАЗССклад;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ПолучитьЗначениеАЗССклад()

&НаСервереБезКонтекста
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
КонецФункции

&НаКлиенте
Процедура ЭтоАЗССкладПриИзмененииПродолжение(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		УстановитьТипПоляКонтрагентСклад();
		ОбновитьНадписьКонтрагентСклад();
	Иначе 
		Объект.ЭтоАЗССклад = ДопПараметры.СтароеЗначение;
	КонецЕсли;
	
КонецПроцедуры

// Подключаемый динамически обработчик оповещения
&НаКлиенте
Процедура ОписаниеОповещенияВыбораГСМ(Результат, ДопПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекСтрока = Элементы.СоответствиеГСМ.ТекущиеДанные;
	ТекСтрока.ГСМ = Результат;
	
	Если ТекСтрока.ГСМ <> ДопПараметры.ЗначениеГСМДоИзменения Тогда 
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровГазпром()
	Если Объект.СоответствиеГСМ.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Do you want to clear the table before filling?';ru='Очистить таблицу перед заполнением?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузкаТоваровГазпромЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНетОтмена,,КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	ЗагрузкаТоваровГазпромФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровЛукойл()
	Если Объект.СоответствиеГСМ.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Do you want to clear the table before filling?';ru='Очистить таблицу перед заполнением?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузкаТоваровЛукойлЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНетОтмена,,КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	ЗагрузкаТоваровЛукойлФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровРоснефть()
	Если Объект.СоответствиеГСМ.Количество() > 0 Тогда
		ТекстНСТР = НСтр("en='Do you want to clear the table before filling?';ru='Очистить таблицу перед заполнением?'");
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗагрузкаТоваровРоснефтьЗавершение", ЭтотОбъект), ТекстНСТР, РежимДиалогаВопрос.ДаНетОтмена,,КодВозвратаДиалога.Нет);
		Возврат;
	КонецЕсли;
	
	ЗагрузкаТоваровРоснефтьФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровЛукойлЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Объект.СоответствиеГСМ.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗагрузкаТоваровЛукойлФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровРоснефтьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Объект.СоответствиеГСМ.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗагрузкаТоваровРоснефтьФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаТоваровГазпромЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Объект.СоответствиеГСМ.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
	
	ЗагрузкаТоваровГазпромФрагмент();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеВводаГруппыКартНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекстОшибки = "";
	СтруктураПараметровУчетнойЗаписи = уатЗагрузкаПЦ.ПолучитьСтруктуруПараметровДляРаботыСПЦ(Объект.УчетнаяЗаписьПЦ);
	МассивГрупп = уатЗагрузкаПЦ.Газпромнефть_ПолучитьМассивГруппКарт(СтруктураПараметровУчетнойЗаписи, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
	
	Элементы.ПолеВводаГруппыКарт.СписокВыбора.Очистить();
	
	Для Каждого ТекГруппа Из МассивГрупп Цикл
		Элементы.ПолеВводаГруппыКарт.СписокВыбора.Добавить(ТекГруппа.Идентификатор, ТекГруппа.Наименование);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПолеВводаГруппыКартОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПрикрепитьТегГруппыКарт(ВыбранноеЗначение);
	Элемент.ОбновитьТекстРедактирования();
	
КонецПроцедуры

&НаКлиенте
Процедура ОблакоТеговГруппыКартОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТегИД = Сред(НавигационнаяСсылкаФорматированнойСтроки, СтрДлина("Тег_") + 1);
	СтрокаТегов = Объект.ГруппыКарт.НайтиСтроки(Новый Структура("IDГруппы", ТегИД));
	Если СтрокаТегов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ГруппыКарт.Удалить(СтрокаТегов[0]);
	
	ОбновитьЭлементыТеговГруппыКарт();
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ПрикрепитьТегГруппыКарт(Тег)
	
	Если Объект.ГруппыКарт.НайтиСтроки(Новый Структура("IDГруппы", Тег)).Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеТега = Элементы.ПолеВводаГруппыКарт.СписокВыбора.НайтиПоЗначению(Тег);
	
	СтрокаТегов = Объект.ГруппыКарт.Добавить();
	НавигационнаяСсылка = "Тег_" + Тег;

	СтрокаТегов.IDГруппы            = Тег;
	СтрокаТегов.Наименование        = ДанныеТега.Представление;
	СтрокаТегов.ПометкаУдаления     = Ложь;
	СтрокаТегов.Представление       = ФорматированнаяСтрокаПредставленияТега(ДанныеТега.Представление, Ложь, НавигационнаяСсылка);
	СтрокаТегов.ДлинаТега           = СтрДлина(ДанныеТега.Представление);
	
	ОбновитьЭлементыТеговГруппыКарт();
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыТеговГруппыКарт()
	
	Для Каждого ТекСтрока Из Объект.ГруппыКарт Цикл
		Если ТекСтрока.Представление = Неопределено Тогда
			ПрочитатьДанныеТегов();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	ФС = Объект.ГруппыКарт.Выгрузить(, "Представление").ВыгрузитьКолонку("Представление");
	
	Индекс = ФС.Количество()-1;
	Пока Индекс > 0 Цикл
		ФС.Вставить(Индекс, "  ");
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Элементы.ОблакоТеговГруппыКарт.Заголовок	= Новый ФорматированнаяСтрока(ФС);
	Элементы.ОблакоТеговГруппыКарт.Видимость	= ФС.Количество() > 0;
	
	Если Объект.ГруппыКарт.Количество() > 0 Тогда
		Элементы.ПолеВводаГруппыКарт.ПодсказкаВвода = Нстр("ru = 'Отчет будет сформирован по группам карт'");
	Иначе
		Элементы.ПолеВводаГруппыКарт.ПодсказкаВвода = Нстр("ru = 'Отчет будет сформирован по всем картам'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ФорматированнаяСтрокаПредставленияТега(НаименованиеТега, ПометкаУдаления, НавигационнаяСсылкаФС)
	
	#Если Клиент Тогда
		Цвет		 = ОбщегоНазначенияКлиентПовтИсп.ЦветСтиля("ТекстВторостепеннойНадписи");
		БазовыйШрифт = ОбщегоНазначенияКлиентПовтИсп.ШрифтСтиля("ОбычныйШрифтТекста");
	#Иначе
		Цвет		 = ЦветаСтиля.ТекстВторостепеннойНадписи;
		БазовыйШрифт = ШрифтыСтиля.ОбычныйШрифтТекста;
	#КонецЕсли
	
	Шрифт = Новый Шрифт(БазовыйШрифт,,,Истина,,?(ПометкаУдаления, Истина, Неопределено));
	
	КомпонентыФС = Новый Массив;
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(НаименованиеТега + Символы.НПП, Шрифт, Цвет));
	КомпонентыФС.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Очистить, , , , НавигационнаяСсылкаФС));
	
	Возврат Новый ФорматированнаяСтрока(КомпонентыФС);
	
КонецФункции

&НаСервере
Процедура ПрочитатьДанныеТегов()
		
	Для Каждого ТекСтрока Из Объект.ГруппыКарт Цикл
		НавигационнаяСсылкаФС   = "Тег_" + ТекСтрока.IDГруппы;
		ТекСтрока.Представление = ФорматированнаяСтрокаПредставленияТега(ТекСтрока.Наименование, ТекСтрока.ПометкаУдаления, НавигационнаяСсылкаФС);
		ТекСтрока.ДлинаТега     = СтрДлина(ТекСтрока.Наименование);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогВыбораФайлаВнешнейОбработки(Подключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ Подключено Тогда
		
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ТекстСообщения = НСтр("ru = 'Для продолжении работы необходимо установить расширение для веб-клиента ""1С:Предприятие"". Установить?'");
		ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Возврат;
		
	КонецЕсли;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.ПолноеИмяФайла = НСтр("en = 'УниверсальнаяЗагрузкаДанныхПЦ'; ru = 'УниверсальнаяЗагрузкаДанныхПЦ'") + ".epf";
	ДиалогВыбораФайла.Фильтр = НСтр("en='External processing';ru='Внешняя обработка'") + "(*.epf)|*.epf";
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Заголовок = НСтр("en='Select an external data processor file';ru='Выберите файл внешней обработки'");

	ДополнительныеПараметры = Новый Структура();
	Оповещение = Новый ОписаниеОповещения("СохранитьШаблонФайлаПослеВыбораФайла", ЭтотОбъект, ДополнительныеПараметры);
	
	ДиалогВыбораФайла.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьУстановкуРасширенияРаботыСФайламиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		НачатьУстановкуРасширенияРаботыСФайлами();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
