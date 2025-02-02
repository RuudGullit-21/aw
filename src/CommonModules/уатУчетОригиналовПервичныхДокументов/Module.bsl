////////////////////////////////////////////////////////////////////////////////
// Подсистема "Учет первичных документов".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет объекты конфигурации, в формах списках которых размещены команды учета оригиналов первичных документов,
//
// Параметры:
//  СписокОбъектов - Массив из Строка - менеджеры объектов с процедурой ДобавитьКомандыПечати.
//
Процедура ПриОпределенииОбъектовСКомандамиУчетаОригиналов(СписокОбъектов) Экспорт
	
	СписокОбъектов.Добавить("Документ.уатВозвратТоваров.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатДоверенность.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатЗаявкаНаРемонт.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатПеремещениеТоваров.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатПоступлениеТоваровУслуг.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатРеализацияУслуг.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатРемонтныйЛист.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатСчетНаОплатуПокупателю.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатСчетНаОплатуПоставщика.Форма.ФормаСписка");
	СписокОбъектов.Добавить("Документ.уатТТД.Форма.ФормаСписка");
	Если НЕ уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД() Тогда
		СписокОбъектов.Добавить("Документ.уатАвансовыйОтчет.Форма.ФормаСписка");
		СписокОбъектов.Добавить("Документ.уатАктСверкиВзаиморасчетов_уэ.Форма.ФормаСписка");
		СписокОбъектов.Добавить("Документ.уатЗаказПеревозчику_уэ.Форма.ФормаСписка");
		СписокОбъектов.Добавить("Документ.уатПакетСопроводительныхДокументов.Форма.ФормаСписка");
	КонецЕсли;
		
КонецПроцедуры

// Отображает надпись с датой посл. изменения оригиналов первичных документов
//
// Параметры:
//  ЭтаФорма				 - ФормаКлиентскогоПриложения - Форма документа
//  ГруппаПервичныеДокументы - ГруппаФормы                - место отображения даты последнего изменения оригинала
//
Процедура ОтобразитьДатуПоследнегоИзмененияПервичныхДокументов(ЭтаФорма, ГруппаПервичныеДокументы) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетОригиналовПервичныхДокументов") = Ложь
		Или Не ПравоДоступа("Чтение", Метаданные.РегистрыСведений.СостоянияОригиналовПервичныхДокументов) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СостоянияОригиналовПервичныхДокументов.ДатаПоследнегоИзменения КАК ДатаПоследнегоИзменения
	|ИЗ
	|	РегистрСведений.СостоянияОригиналовПервичныхДокументов КАК СостоянияОригиналовПервичныхДокументов
	|ГДЕ
	|	СостоянияОригиналовПервичныхДокументов.Владелец = &Владелец");
	Запрос.УстановитьПараметр("Владелец", ЭтаФорма.Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НадписьДата = СтрШаблон("Последнее изменение от %1", Формат(Выборка.ДатаПоследнегоИзменения, "ДФ=dd.MM.yyyy"));
	Иначе
		НадписьДата = "";
	КонецЕсли;
	
	ЭлементНадписьДата = ЭтаФорма.Элементы.Найти("НадписьДатаИзмененияПервичныхДокументов");
	Если ЭлементНадписьДата = Неопределено Тогда
		ЭлементНадписьДата = ЭтаФорма.Элементы.Добавить("НадписьДатаИзмененияПервичныхДокументов",
			Тип("ДекорацияФормы"), ГруппаПервичныеДокументы);
	КонецЕсли;
	ЭлементНадписьДата.Заголовок = НадписьДата;
	
КонецПроцедуры

// Записывает движения регистра сведений РеестрДокументов в документах,
//  которые используют функционал УчетОригиналовПервичныхДокументов.
//  Вызывается в процедуре ОбработкаПроведения() или ПриЗаписи() модуля объекта.
//
// Параметры:
//  ДокументСсылка - ОпределяемыйТип.ОбъектСУчетомОригиналовПервичныхДокументов - Владелец записи
//
Процедура СформироватьДвиженияРеестрДокументов(ДокументСсылка) Экспорт
	
	// Пользователь, записывающий документ, уже имеет права на его запись/проведение,
	// поэтому запись в Реестр документов здесь всегда разрешена.
	// Пример, Механик проводящий Рем. лист, но не имеющий прав на запись в Реестр документов
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетОригиналовПервичныхДокументов") = Ложь Тогда
		Возврат;
	КонецЕсли;
			
	МетаданныеОбъекта = ДокументСсылка.Метаданные();
	
	НоваяЗапись = РегистрыСведений.уатРеестрДокументов.СоздатьМенеджерЗаписи();
	
	НоваяЗапись.Ссылка           = ДокументСсылка;
	НоваяЗапись.ТипСсылки        = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("Имя",
		МетаданныеОбъекта.Имя);
	НоваяЗапись.ДатаДокументаИБ  = ДокументСсылка.Дата;
	НоваяЗапись.НомерДокументаИБ = ДокументСсылка.Номер;
	НоваяЗапись.Организация      = ДокументСсылка.Организация;
	
	Если МетаданныеОбъекта.Реквизиты.Найти("Подразделение") <> Неопределено Тогда
		НоваяЗапись.Подразделение = ДокументСсылка.Подразделение;
	ИначеЕсли МетаданныеОбъекта.Реквизиты.Найти("ПодразделениеОрганизации") <> Неопределено Тогда
		НоваяЗапись.Подразделение = ДокументСсылка.ПодразделениеОрганизации;
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("Контрагент") <> Неопределено Тогда
		НоваяЗапись.Контрагент = ДокументСсылка.Контрагент;
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("СуммаДокумента") <> Неопределено Тогда
		НоваяЗапись.Сумма = ДокументСсылка.СуммаДокумента;
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("ВалютаДокумента") <> Неопределено Тогда
		НоваяЗапись.Валюта = ДокументСсылка.ВалютаДокумента;
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("ДатаВходящегоДокумента") <> Неопределено Тогда
		НоваяЗапись.ДатаПервичногоДокумента = ДокументСсылка.ДатаВходящегоДокумента;
	КонецЕсли;
	Если МетаданныеОбъекта.Реквизиты.Найти("НомерВходящегоДокумента") <> Неопределено Тогда
		НоваяЗапись.НомерПервичногоДокумента = ДокументСсылка.НомерВходящегоДокумента;
	КонецЕсли;
	
	НоваяЗапись.Записать();
	
КонецПроцедуры
	
#КонецОбласти
