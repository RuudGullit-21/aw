///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает шаблон имени профиля безопасности для внешнего модуля.
// Функция должна возвращать одно и то же значение при многократном вызове.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка на внешний модуль.
//
// Возвращаемое значение:
//   Строка - шаблон имя профиля безопасности, содержащий символы
//  "%1", вместо которых в дальнейшем будет подставлен уникальный идентификатор.
//
Функция ШаблонИмениПрофиляБезопасности(Знач ВнешнийМодуль) Экспорт
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийМодуль, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		Возврат "AdditionalReport_%1"; // Не локализуется
		
	Иначе
		
		Возврат "AdditionalDataProcessor_%1"; // Не локализуется
		
	КонецЕсли;
	
КонецФункции

// Возвращает пиктограмму, отображающую внешний модуль.
//
// Параметры:
//  ВнешнийМодуль - ЛюбаяСсылка - ссылка на внешний модуль
//
// Возвращаемое значение:
//   Картинка.
//
Функция ПиктограммаВнешнегоМодуля(Знач ВнешнийМодуль) Экспорт
	
	Вид = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийМодуль, "Вид");
	Если Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Или Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		Возврат БиблиотекаКартинок.Отчет;
		
	Иначе
		
		Возврат БиблиотекаКартинок.Обработка;
		
	КонецЕсли;
	
КонецФункции

// Возвращает словарь представлений для внешних модулей контейнера.
//
// Возвращаемое значение:
//   Структура:
//   * Именительный - Строка - представление типа внешнего модуля в именительном падеже,
//   * Родительный - Строка - представление типа внешнего модуля в родительном падеже.
//
Функция СловарьКонтейнераВнешнегоМодуля() Экспорт
	
	Результат = Новый Структура();
	
	Результат.Вставить("Именительный", НСтр("ru = 'Дополнительный отчет или обработка'; en = 'Additional report or data processor'"));
	Результат.Вставить("Родительный", НСтр("ru = 'Дополнительного отчета или обработки'; en = 'Additional report of data processor'"));
	
	Возврат Результат;
	
КонецФункции

// Возвращает массив ссылочных объектов метаданных, которые могут использоваться в
//  качестве контейнера внешних модулей.
//
// Возвращаемое значение:
//   Массив из ОбъектМетаданных
//
Функция КонтейнерыВнешнихМодулей() Экспорт
	
	Результат = Новый Массив();
	Результат.Добавить(Метаданные.Справочники.ДополнительныеОтчетыИОбработки);
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ИнтеграцияПодсистемБСП.ПриРегистрацииМенеджеровВнешнихМодулей
Процедура ПриРегистрацииМенеджеровВнешнихМодулей(Менеджеры) Экспорт
	
	Менеджеры.Добавить(ДополнительныеОтчетыИОбработкиВБезопасномРежимеСлужебный);
	
КонецПроцедуры

// См. РаботаВБезопасномРежимеПереопределяемый.ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам.
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	НовыеЗапросы = ЗапросыРазрешенийДополнительныхОбработок();
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ЗапросыРазрешений, НовыеЗапросы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЗапросыРазрешенийДополнительныхОбработок(Знач ЗначениеФО = Неопределено)
	
	Если ЗначениеФО = Неопределено Тогда
		ЗначениеФО = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Результат = Новый Массив();
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ДополнительныеОтчетыИОбработки.Разрешения КАК ДополнительныеОтчетыИОбработкиРазрешения
		|ГДЕ
		|	ДополнительныеОтчетыИОбработкиРазрешения.Ссылка.Публикация <> &Публикация";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Публикация", Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		НовыеЗапросы = ЗапросыРазрешенийДополнительнойОбработки(Объект, ЗначениеФО);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат, НовыеЗапросы);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//   Объект - СправочникСсылка.ДополнительныеОтчетыИОбработки
//   ЗначениеФО - Булево
//              - Неопределено
//   ПометкаУдаления - Булево
// Возвращаемое значение:
//   Массив
//
Функция ЗапросыРазрешенийДополнительнойОбработки(Знач Объект, Знач ЗначениеФО = Неопределено, Знач ПометкаУдаления = Неопределено)
	
	РазрешенияВДанных = Объект.Разрешения.Выгрузить();
	ЗапрашиваемыеРазрешения = Новый Массив();
	
	Если ЗначениеФО = Неопределено Тогда
		ЗначениеФО = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеОтчетыИОбработки");
	КонецЕсли;
	
	Если ПометкаУдаления = Неопределено Тогда
		ПометкаУдаления = Объект.ПометкаУдаления;
	КонецЕсли;
	
	ОчиститьРазрешения = Ложь;
	
	Если Не ЗначениеФО Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	Если Объект.Публикация = Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Отключена Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		ОчиститьРазрешения = Истина;
	КонецЕсли;
	
	МодульРаботаВБезопасномРежимеСлужебный = ОбщегоНазначения.ОбщийМодуль("РаботаВБезопасномРежимеСлужебный");
	
	Если Не ОчиститьРазрешения Тогда
		
		БылиРазрешения = МодульРаботаВБезопасномРежимеСлужебный.РежимПодключенияВнешнегоМодуля(Объект.Ссылка) <> Неопределено;
		ЕстьРазрешения = Объект.Разрешения.Количество() > 0;
		
		Если БылиРазрешения Или ЕстьРазрешения Тогда
			
			ЗапрашиваемыеРазрешения = Новый Массив();
			Для Каждого РазрешениеВДанных Из РазрешенияВДанных Цикл
				Разрешение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(МодульРаботаВБезопасномРежимеСлужебный.Пакет(), РазрешениеВДанных.ВидРазрешения));
				СвойстваВДанных = РазрешениеВДанных.Параметры.Получить();
				ЗаполнитьЗначенияСвойств(Разрешение, СвойстваВДанных);
				ЗапрашиваемыеРазрешения.Добавить(Разрешение);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат МодульРаботаВБезопасномРежимеСлужебный.ЗапросРазрешенийДляВнешнегоМодуля(Объект.Ссылка, ЗапрашиваемыеРазрешения);
	
КонецФункции

#КонецОбласти