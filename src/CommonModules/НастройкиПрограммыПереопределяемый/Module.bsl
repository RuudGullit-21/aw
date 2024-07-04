///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбслуживаниеПриСозданииНаСервере(Форма) Экспорт
	
	// {УАТ}
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Константы.уатКонфигурацияДляРФ.Получить() Тогда 
		// Необходимо скрыть элементы формы.
		Если Не Форма.Элементы.Найти("ГруппаРезервноеКопированиеИВосстановление") = Неопределено Тогда 
			Форма.Элементы.ГруппаРезервноеКопированиеИВосстановление.Видимость = Ложь;
		КонецЕсли;
		Если Не Форма.Элементы.Найти("УстановкаОбновлений") = Неопределено Тогда 
			Форма.Элементы.УстановкаОбновлений.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
		
	#Область ОтключениеРегламентныхЗаданий
	
	// Добавление группы элементов
	ТекГруппаЭлементов = Форма.Элементы.Добавить("Группа" + "ОтключитьРегламентныеЗадания", Тип("ГруппаФормы"), Форма.Элементы.ГруппаРегламентныеЗадания);
	ТекГруппаЭлементов.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ТекГруппаЭлементов.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	ТекГруппаЭлементов.ШиринаПодчиненныхЭлементов = ШиринаПодчиненныхЭлементовФормы.Одинаковая;
	ТекГруппаЭлементов.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ТекГруппаЭлементов.ОтображатьЗаголовок        = Ложь;
	ТекГруппаЭлементов.Ширина                     = 43;
	ТекГруппаЭлементов.РастягиватьПоГоризонтали   = Ложь;
		
	// Добавление кнопки-гиперссылки
	ТекГиперссылка 			 = Форма.Элементы.Добавить("ОтключитьРегламентныеЗадания", Тип("ДекорацияФормы"), ТекГруппаЭлементов);
	ТекГиперссылка.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Отключить регламентные задания'"),,,, "e1cib/command/ОбщаяКоманда.уатОтключитьРегламентныеЗадания");
	
	// Текстовая подсказка
	ТекПодсказка 			= Форма.Элементы.Добавить("ОтключитьРегламентныеЗадания" + "Подсказка", Тип("ДекорацияФормы"), ТекГруппаЭлементов);
	ТекПодсказка.Заголовок  = "Все регламентные задания будут отключены.";
	ТекПодсказка.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;

	#КонецОбласти

	// {/УАТ}
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ОбщиеНастройки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОбщиеНастройкиПриСозданииНаСервере(Форма) Экспорт
	
	// {УАТ}
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ Константы.уатКонфигурацияДляРФ.Получить() Тогда 
		// Необходимо скрыть элементы формы.
		Если Не Форма.Элементы.Найти("ГруппаЭлектроннаяПодписьИШифрование") = Неопределено Тогда 
			Форма.Элементы.ГруппаЭлектроннаяПодписьИШифрование.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	// {/УАТ}
	
	// {УАТ}
	// Добавление на форму настроек часового пояса
	// Добавление реквизита "Часовой пояс"
	ДобавляемыеРеквизиты = Новый Массив;
	РеквизитЧасовойПоясПрограммы = Новый РеквизитФормы("ЧасовойПоясПрограммы", Новый ОписаниеТипов("Строка"),,НСтр("ru='Часовой пояс'; en = 'Time zone'"));
	ДобавляемыеРеквизиты.Добавить(РеквизитЧасовойПоясПрограммы);
	Форма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	Форма.ЧасовойПоясПрограммы = ПолучитьЧасовойПоясИнформационнойБазы();
	Если ПустаяСтрока(Форма.ЧасовойПоясПрограммы) Тогда
		Форма.ЧасовойПоясПрограммы = ЧасовойПояс();
	КонецЕсли;
	
	// Добавление группы элементов
	ГруппаВладелец = Форма.Элементы.Найти("ГруппаНастройкиПрограммы");
	Если ГруппаВладелец <> Неопределено Тогда
		ТекГруппа = Форма.Элементы.Добавить("ГруппаЧасовойПоясПрограммы", Тип("ГруппаФормы"), ГруппаВладелец);
	Иначе
		ТекГруппа = Форма.Элементы.Добавить("ГруппаЧасовойПоясПрограммы", Тип("ГруппаФормы"));
	КонецЕсли;
	ТекГруппа.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ТекГруппа.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	ТекГруппа.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ТекГруппа.ОтображатьЗаголовок        = Ложь;
	ТекГруппа.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	ТекГруппа.Подсказка = НСтр("ru = 'Часовой пояс, в котором ведется учет в программе. Даты всех документов и других данных вводятся и хранятся в этом часовом поясе.';
		|en = 'The time zone in which the account is maintained in the program. The dates of all documents and other data are entered and stored in this time zone.'");
	
	// Добавление элемента формы "Часовой пояс"
	ЭлементЧасовойПоясПрограммы = Форма.Элементы.Добавить("ЧасовойПоясПрограммы", Тип("ПолеФормы"), ТекГруппа);
	ЭлементЧасовойПоясПрограммы.Вид = ВидПоляФормы.ПолеВвода;
	ЭлементЧасовойПоясПрограммы.ПутьКДанным = "ЧасовойПоясПрограммы";
	ЭлементЧасовойПоясПрограммы.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Лево;
	ЭлементЧасовойПоясПрограммы.РастягиватьПоГоризонтали = Ложь;
	ЭлементЧасовойПоясПрограммы.КнопкаВыпадающегоСписка = Истина;
	ЭлементЧасовойПоясПрограммы.УстановитьДействие("ПриИзменении", "Подключаемый_ПриИзмененииРеквизита");
	Форма.Элементы.ЧасовойПоясПрограммы.СписокВыбора.ЗагрузитьЗначения(ПолучитьДопустимыеЧасовыеПояса());
	
	// Добавление гиперссылки команды "Время текущего сеанса"
	ТекГиперссылка 			 = Форма.Элементы.Добавить("ВремяТекущегоСеанса", Тип("ДекорацияФормы"), ТекГруппа);
	ТекГиперссылка.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Время текущего сеанса'; en = 'Current session time'"),,,, "e1cib/command/ОбщаяКоманда.ВремяТекущегоСеанса");
	// {/УАТ}
	
	// {УАТ}
	// Добавление на форму команды "Перенос дополнительных реквизитов при вводе на основании"
	
	// Добавление группы элементов
	ГруппаВладелец = Форма.Элементы.Найти("ГруппаДополнительныеРеквизитыИлиСведения");
	Если ГруппаВладелец <> Неопределено Тогда
		ТекГруппа = Форма.Элементы.Добавить("ГруппаПереносДополнительныхРеквизитов", Тип("ГруппаФормы"), ГруппаВладелец);
	Иначе
		ТекГруппа = Форма.Элементы.Добавить("ГруппаПереносДополнительныхРеквизитов", Тип("ГруппаФормы"));
	КонецЕсли;
	ТекГруппа.Вид                        = ВидГруппыФормы.ОбычнаяГруппа;
	ТекГруппа.Группировка                = ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяЕслиВозможно;
	ТекГруппа.Отображение                = ОтображениеОбычнойГруппы.Нет;
	ТекГруппа.ОтображатьЗаголовок        = Ложь;
	ТекГруппа.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	ТекГруппа.Подсказка = НСтр("ru = 'Настройки переноса дополнительных реквизитов при вводе на основании для документов.';
		|en = 'Settings for filling of additional attributes for input on basis of documents.'");
	
	// Добавление гиперссылки команды "Перенос дополнительных реквизитов при вводе на основании"
	ТекГиперссылка           = Форма.Элементы.Добавить("ПереносДополнительныхРеквизитов", Тип("ДекорацияФормы"), ТекГруппа);
	ТекГиперссылка.Заголовок = Новый ФорматированнаяСтрока(НСтр("ru = 'Перенос дополнительных реквизитов при вводе на основании'"),,,,
		"e1cib/command/РегистрСведений.уатПереносДополнительныхРеквизитов.Команда.НастройкиПереносаДополнительныхРеквизитов");
	
	// {/УАТ}
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Обслуживание обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиПользователейИПравПриСозданииНаСервере(Форма) Экспорт
	
	// {УАТ}
	ТекстПодсказкиПерсДанные = "Внимание! Персональные данные физических лиц и сотрудников будут автоматически скрыты. 
	|В результате скрытия значения реквизитов будут заменены строкой вида b0d4ce5d-2757-4699-948c-cfa72ba94f86 без возможности восстановления.
	|Состав скрываемых данных необходимо настроить в форме ""Настройки регистрации событий доступа к персональным данным"".
	|Причиной скрытия данных может быть истечение срока действия согласия субъекта или его отсутствие."; 
	Форма.Элементы.ГруппаДнейДоСкрытия.Подсказка = ТекстПодсказкиПерсДанные;
	// {/УАТ}
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ИнтернетПоддержкаИСервисы обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ИнтернетПоддержкаИСервисыПриСозданииНаСервере(Форма) Экспорт
	
	// {УАТ}
	УстановитьПривилегированныйРежим(Истина);
	Если НЕ уатОбщегоНазначения.КонфигурацияДляРФ() Тогда 
		// Необходимо скрыть элементы формы.
		Если Не Форма.Элементы.Найти("БИПГруппаОбновлениеПрограммы") = Неопределено Тогда 
			Форма.Элементы.БИПГруппаОбновлениеПрограммы.Видимость = Ложь;
		КонецЕсли;
		Если Не Форма.Элементы.Найти("БИПГруппаНовости") = Неопределено Тогда 
			Форма.Элементы.БИПГруппаНовости.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	// {/УАТ}
	
КонецПроцедуры

// Предназначена для внесения изменений в форму Органайзер обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ОрганайзерПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму СинхронизацияДанных обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура СинхронизацияДанныхПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму НастройкиРаботыСФайлами обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура НастройкиРаботыСФайламиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

// Предназначена для внесения изменений в форму ПечатныеФормыОтчетыИОбработки обработки
// ПанельАдминистрированияБСП без снятия формы с поддержки.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - для внесения изменений.
//
Процедура ПечатныеФормыОтчетыИОбработкиПриСозданииНаСервере(Форма) Экспорт
	
КонецПроцедуры

#КонецОбласти